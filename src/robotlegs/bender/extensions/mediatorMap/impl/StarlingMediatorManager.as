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
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;
	

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

		private var _factory:IMediatorFactory;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function StarlingMediatorManager(factory:IMediatorFactory)
		{
			_factory = factory;
			_factory.addEventListener(MediatorFactoryEvent.MEDIATOR_CREATE, onMediatorCreate);
			_factory.addEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE, onMediatorRemove);
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

		private function onMediatorCreate(event:MediatorFactoryEvent):void
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

			// Is this a UIComponent that needs to be initialized?
			if (flexAvailable && (displayObject is UIComponentClass) && !displayObject['initialized'])
			{
				displayObject.addEventListener(CREATION_COMPLETE, function(e:Event):void
				{
					displayObject.removeEventListener(CREATION_COMPLETE, arguments.callee);
					// ensure that we haven't been removed in the meantime
					if (_factory.getMediator(displayObject, event.mapping))
						initializeMediator(displayObject, mediator);
				});
			}
			else
			{
				initializeMediator(displayObject, mediator);
			}
		}

		private function onMediatorRemove(event:MediatorFactoryEvent):void
		{
			const view:DisplayObject = event.mediatedItem as DisplayObject;
			if (!view)
				return;
			view.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			// note: as far as I know, the re-parenting issue does not exist with Flex 4+.
			// question: should we bother handling re-parenting?
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
