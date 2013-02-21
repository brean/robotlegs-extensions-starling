//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.contextView
{
	import org.hamcrest.object.instanceOf;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.ILogger;
	
	import starling.display.DisplayObjectContainer;

	/**
	 * <p>This Extension waits for a DisplayObjectContainer to be added as a configuration
	 * and maps that container into the context's injector.</p>
	 *
	 * <p>It should be installed before context initialization.</p>
	 */
	public class StarlingContextViewExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function extend(context:IContext):void
		{
			_injector = context.injector;
			_logger = context.getLogger(this);
			context.addConfigHandler(instanceOf(StarlingContextView), handleContextView);
			context.beforeInitializing(beforeInitializing);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextView(contextView:StarlingContextView):void
		{
			if (_injector.hasDirectMapping(StarlingContextView))
			{
				_logger.warn('A contextView has already been installed, ignoring {0}', [contextView.view]);
			}
			else
			{
				_logger.debug("Mapping {0} as contextView", [contextView.view]);
				_injector.map(StarlingContextView).toValue(contextView);
			}
		}

		private function beforeInitializing():void
		{
			if (!_injector.hasDirectMapping(StarlingContextView))
			{
				_logger.error("A ContextView must be installed if you install the ContextViewExtension.");
			}
		}
	}
}
