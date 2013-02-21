//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity
{
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import org.hamcrest.object.instanceOf;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.contextView.StarlingContextView;
	import robotlegs.bender.extensions.modularity.impl.StarlingContextViewBasedExistenceWatcher;
	import robotlegs.bender.extensions.modularity.impl.StarlingModularContextEvent;
	import robotlegs.bender.extensions.modularity.impl.StarlingViewManagerBasedExistenceWatcher;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.UID;
	

	/**
	 * <p>This extension allows a context to inherit dependencies from a parent context,
	 * and to expose its dependences to child contexts.</p>
	 *
	 * <p>It should be installed before context initialization.</p>
	 */
	public class StarlingModularityExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(StarlingModularityExtension);

		private var _context:IContext;

		private var _injector:Injector;

		private var _logger:ILogger;

		private var _inherit:Boolean;

		private var _expose:Boolean;

		private var _contextView:DisplayObjectContainer;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Modularity
		 *
		 * @param inherit Should this context inherit dependencies?
		 * @param export Should this context expose its dependencies?
		 */
		public function StarlingModularityExtension(inherit:Boolean = true, expose:Boolean = true)
		{
			_inherit = inherit;
			_expose = expose;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_context = context;
			_injector = context.injector;
			_logger = context.getLogger(this);
			_context.addConfigHandler(instanceOf(StarlingContextView), handleContextView);
			_context.beforeInitializing(beforeInitializing);
		}

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/
		private function beforeInitializing():void
		{
			_contextView || _logger.error("Context has no ContextView, and ModularityExtension doesn't allow this.");
		}

		private function handleContextView(contextView:StarlingContextView):void
		{
			_contextView = contextView.view;
			_expose && configureExistenceWatcher();
			_inherit && configureExistenceBroadcaster();
		}

		private function configureExistenceWatcher():void
		{
			if (_injector.hasDirectMapping(IViewManager))
			{
				_logger.debug("Context has a ViewManager. Configuring view manager based context existence watcher...");
				const viewManager:IViewManager = _injector.getInstance(IViewManager);
				new StarlingViewManagerBasedExistenceWatcher(_context, viewManager);
			}
			else
			{
				_logger.debug("Context has a ContextView. Configuring context view based context existence watcher...");
				new StarlingContextViewBasedExistenceWatcher(_context, _contextView);
			}
		}

		private function configureExistenceBroadcaster():void
		{
			if (_contextView.stage)
			{
				broadcastContextExistence();
			}
			else
			{
				_logger.debug("Context view is not yet on stage. Waiting...");
				_contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}

		private function onAddedToStage(event:Event):void
		{
			_logger.debug("Context view is now on stage. Continuing...");
			_contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			broadcastContextExistence();
		}

		private function broadcastContextExistence():void
		{
			_logger.debug("Context configured to inherit. Broadcasting existence event...");
			_contextView.dispatchEvent(new StarlingModularContextEvent(StarlingModularContextEvent.CONTEXT_ADD, _context));
		}
	}
}
