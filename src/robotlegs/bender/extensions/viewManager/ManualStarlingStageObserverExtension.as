//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager
{
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.viewManager.impl.StarlingContainerRegistry;
	import robotlegs.bender.extensions.viewManager.impl.StarlingManualStageObserver;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.ILogger;

	public class ManualStarlingStageObserverExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		// Really? Yes, there can be only one.
		private static var _manualStageObserver:StarlingManualStageObserver;

		private static var _installCount:uint;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;
		
		private var _logger:ILogger;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_installCount++;
			_injector = context.injector;
			_logger = context.getLogger(this);
			context.whenInitializing(whenInitializing);
			context.whenDestroying(whenDestroying);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function whenInitializing():void
		{
			// Hark, an actual Singleton!
			if (!_manualStageObserver)
			{
				const containerRegistry:StarlingContainerRegistry = _injector.getInstance(StarlingContainerRegistry);
				_logger.debug("Creating genuine ManualStageObserver Singleton");
				_manualStageObserver = new StarlingManualStageObserver(containerRegistry);
			}
		}

		private function whenDestroying():void
		{
			_installCount--;
			if (_installCount == 0)
			{
				_logger.debug("Destroying genuine ManualStageObserver Singleton");
				_manualStageObserver.destroy();
				_manualStageObserver = null;
			}
		}
	}
}
