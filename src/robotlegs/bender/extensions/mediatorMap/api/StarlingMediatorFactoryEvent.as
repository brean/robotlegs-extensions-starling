//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{
	import flash.events.Event;

	/**
	 * Mediator Existence Event
	 * @private
	 */
	public class StarlingMediatorFactoryEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const MEDIATOR_CREATE:String = 'mediatorCreate';

		public static const MEDIATOR_REMOVE:String = 'mediatorRemove';

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _mediator:Object;

		/**
		 * The mediator instance associated with this event
		 */
		public function get mediator():Object
		{
			return _mediator;
		}

		private var _mediatedItem:Object;

		/**
		 * The mediated item associated with this event
		 */
		public function get mediatedItem():Object
		{
			return _mediatedItem;
		}

		private var _mapping:IStarlingMediatorMapping;

		/**
		 * The mediator mapping associated with this event
		 */
		public function get mapping():IStarlingMediatorMapping
		{
			return _mapping;
		}

		private var _factory:IStarlingMediatorFactory;

		/**
		 * The mediator factory associated with this event
		 */
		public function get factory():IStarlingMediatorFactory
		{
			return _factory;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a Mediator Existence Event
		 * @param type
		 * @param mediator
		 * @param mediatedItem
		 * @param mapping
		 * @param factory
		 */
		public function StarlingMediatorFactoryEvent(
			type:String,
			mediator:Object,
			mediatedItem:Object,
			mapping:IStarlingMediatorMapping,
			factory:IStarlingMediatorFactory)
		{
			super(type);
			_mediator = mediator;
			_mediatedItem = mediatedItem;
			_mapping = mapping;
			_factory = factory;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new StarlingMediatorFactoryEvent(type, _mediator, _mediatedItem, _mapping, _factory);
		}
	}
}
