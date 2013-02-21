//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap
{
	import org.swiftsuspenders.Injector;
	
	import robotlegs.bender.extensions.mediatorMap.api.IStarlingMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IStarlingMediatorMap;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.impl.StarlingMediatorManager;
	import robotlegs.bender.extensions.mediatorMap.impl.StarlingMediatorMap;
	import robotlegs.bender.extensions.viewManager.api.IStarlingViewHandler;
	import robotlegs.bender.extensions.viewManager.api.IStarlingViewManager;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;

	public class StarlingMediatorMapExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		private var _mediatorMap:IStarlingMediatorMap;

		private var _viewManager:IStarlingViewManager;

		private var _mediatorManager:StarlingMediatorManager;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_injector = context.injector;
			_injector.map(IStarlingMediatorFactory).toSingleton(MediatorFactory);
			_injector.map(IStarlingMediatorMap).toSingleton(StarlingMediatorMap);
			// todo: figure out why this is done as preInitialize
			context.beforeInitializing(beforeInitializing);
			context.beforeDestroying(beforeDestroying);
			context.whenDestroying(whenDestroying);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

//		private function handleContextPreInitialize():void
//		{
//			_mediatorMap = _injector.getInstance(IStarlingMediatorMap);
//			_mediatorManager = _injector.getInstance(StarlingMediatorManager);
//			if (_injector.satisfiesDirectly(IStarlingViewManager))
//			{
//				_viewManager = _injector.getInstance(IStarlingViewManager);
//				_viewManager.addViewHandler(_mediatorMap as IStarlingViewHandler);
//			}
//		}

		private function beforeInitializing():void
		{
			_mediatorMap = _injector.getInstance(IStarlingMediatorMap);
			_mediatorManager = _injector.instantiateUnmapped(StarlingMediatorManager);
			if (_injector.satisfiesDirectly(IStarlingViewManager))
			{
				_viewManager = _injector.getInstance(IStarlingViewManager);
				_viewManager.addViewHandler(_mediatorMap as IStarlingViewHandler);
			}
		}

		private function beforeDestroying():void
		{
			var mediatorFactory:IStarlingMediatorFactory = _injector.getInstance(IStarlingMediatorFactory);
			mediatorFactory.removeAllMediators();

			if (_injector.satisfiesDirectly(IStarlingViewManager))
			{
				_viewManager = _injector.getInstance(IStarlingViewManager);
				_viewManager.removeViewHandler(_mediatorMap as IStarlingViewHandler);
			}
		}

		private function whenDestroying():void
		{
			if (_injector.satisfiesDirectly(IStarlingMediatorMap))
			{
				_injector.unmap(IStarlingMediatorMap);
			}
			if (_injector.satisfiesDirectly(IStarlingMediatorFactory))
			{
				_injector.unmap(IStarlingMediatorFactory);
			}
		}
	}
}
