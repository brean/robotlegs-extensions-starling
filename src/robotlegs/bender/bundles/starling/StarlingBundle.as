package robotlegs.bender.bundles.starling
{
	
	import robotlegs.bender.bundles.shared.configs.StarlingContextViewListenerConfig;
    import robotlegs.bender.extensions.eventCommandMap.EventCommandMapExtension;
	import robotlegs.bender.extensions.contextView.StarlingContextViewExtension;
	import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtension;
	import robotlegs.bender.extensions.localEventMap.LocalEventMapExtension;
	import robotlegs.bender.extensions.enhancedLogging.TraceLoggingExtension;
	import robotlegs.bender.extensions.mediatorMap.StarlingMediatorMapExtension;
	import robotlegs.bender.extensions.modularity.StarlingModularityExtension;
	import robotlegs.bender.extensions.stageSync.StarlingStageSyncExtension;
	import robotlegs.bender.extensions.viewManager.ManualStageObserverExtension;
	import robotlegs.bender.extensions.viewManager.StarlingStageObserverExtension;
	import robotlegs.bender.extensions.viewManager.StarlingViewManagerExtension;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IBundle;
	
	public class StarlingBundle implements IBundle
	{
		public function extend(context:IContext):void
		{
			context.install(
				TraceLoggingExtension,
				StarlingContextViewExtension,
				EventDispatcherExtension,
				StarlingModularityExtension,
				StarlingStageSyncExtension,
				EventCommandMapExtension,
				LocalEventMapExtension,
				StarlingViewManagerExtension,
				StarlingStageObserverExtension,
				ManualStageObserverExtension,
				StarlingMediatorMapExtension);
			
			context.configure(StarlingContextViewListenerConfig);
		}
	}
}
