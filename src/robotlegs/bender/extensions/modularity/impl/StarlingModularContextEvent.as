//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl
{
	import starling.events.Event;
	import robotlegs.bender.framework.api.IContext;

	/**
	 * Module Context Event
	 * @private
	 */
	public class StarlingModularContextEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const CONTEXT_ADD:String = "contextAdd";

		public static const CONTEXT_REMOVE:String = "contextRemove";

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _context:IContext;

		/**
		 * The context associated with this event
		 */
		public function get context():IContext
		{
			return _context;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a Module Context Event
		 * @param type The event type
		 * @param context The associated context
		 */
		public function StarlingModularContextEvent(type:String, context:IContext)
		{
			super(type, true);
			_context = context;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function clone():Event
		{
			return new StarlingModularContextEvent(type, context);
		}

		override public function toString():String
		{
			return "[ModularContextEvent(context:" + context + ")]";
		}
	}
}
