//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import starling.display.DisplayObject;
	import starling.events.Event;
	import flash.utils.getDefinitionByName;
	import robotlegs.bender.extensions.mediatorMap.api.IStarlingMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.StarlingMediatorFactoryEvent;

	/**
	 * @private
	 */
	public class StarlingMediatorManager
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static var UIComponentClass:Class;

		private static const flexAvailable:Boolean = checkFlex();
		
		private static const CREATION_COMPLETE:String = "creationComplete";

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings:Dictionary = new Dictionary();

		private var _factory:IStarlingMediatorFactory;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function StarlingMediatorManager(factory:IStarlingMediatorFactory)
		{
			_factory = factory;
			_factory.addEventListener(StarlingMediatorFactoryEvent.MEDIATOR_CREATE, onMediatorCreate);
			_factory.addEventListener(StarlingMediatorFactoryEvent.MEDIATOR_REMOVE, onMediatorRemove);
		}

		/*============================================================================*/
		/* Private Static Functions                                                   */
		/*============================================================================*/

		private static function checkFlex():Boolean
		{
			try
			{
				UIComponentClass = getDefinitionByName('mx.core::UIComponent') as Class;
			}
			catch (error:Error)
			{
				// do nothing
			}
			return UIComponentClass != null;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function onMediatorCreate(event:StarlingMediatorFactoryEvent):void
		{
			const mediator:Object = event.mediator;
			const displayObject:DisplayObject = event.mediatedItem as DisplayObject;

			if (!displayObject)
			{
				// Non-display-object was added, initialize and exit
				initializeMediator(event.mediatedItem, mediator);
				return;
			}

			// Watch this view for removal
			displayObject.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			initializeMediator(displayObject, mediator);
		}

		private function onMediatorRemove(event:StarlingMediatorFactoryEvent):void
		{
			const displayObject:DisplayObject = event.mediatedItem as DisplayObject;

			if (displayObject)
				displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			if (event.mediator)
				destroyMediator(event.mediator);
		}

		private function onRemovedFromStage(event:Event):void
		{
			_factory.removeMediators(event.target);
		}

		private function initializeMediator(view:Object, mediator:Object):void
		{
			if (mediator.hasOwnProperty('viewComponent'))
				mediator.viewComponent = view;

			if (mediator.hasOwnProperty('initialize'))
				mediator.initialize();
		}

		private function destroyMediator(mediator:Object):void
		{
			if (mediator.hasOwnProperty('destroy'))
				mediator.destroy();
		}
	}
}
