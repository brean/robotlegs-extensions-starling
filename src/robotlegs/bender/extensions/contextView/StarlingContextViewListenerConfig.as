//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.contextView
{
	import robotlegs.bender.extensions.viewManager.api.IViewManager;

	/**
	 * This configuration file adds the ContextView to the viewManager.
	 *
	 * It requires the ViewManagerExtension, ContextViewExtension
	 * and a ContextView have been installed.
	 */
	public class StarlingContextViewListenerConfig
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject]
		public var contextView:StarlingContextView;

		[Inject]
		public var viewManager:IStarlingViewManager;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		[PostConstruct]
		/**
		 * Adds the Context View to the View Manager at startup
		 */
		public function init():void
		{
			viewManager.addContainer(contextView.view);
		}
	}
}
