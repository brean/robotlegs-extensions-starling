//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import starling.display.DisplayObject;
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.matching.ITypeMatcher;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.api.IStarlingMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IStarlingMediatorMap;
	import robotlegs.bender.extensions.mediatorMap.api.IStarlingMediatorViewHandler;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
	import robotlegs.bender.extensions.viewManager.api.IStarlingViewHandler;
	
	
	public class StarlingMediatorMap implements IMediatorMap, IStarlingViewHandler
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		
		private const _mappers:Dictionary = new Dictionary();
		
		private var _handler:IStarlingMediatorViewHandler;
		
		private var _factory:IStarlingMediatorFactory;
		
		private const NULL_UNMAPPER:IMediatorUnmapper = new NullMediatorUnmapper();
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		public function StarlingMediatorMap(factory:IStarlingMediatorFactory, handler:IStarlingMediatorViewHandler = null)
		{
			_factory = factory;
			_handler = handler || new StarlingMediatorViewHandler(_factory);
		}
		
		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/
		
		/**
		 * @inheritDoc
		 */
		public function mapMatcher(matcher:ITypeMatcher):IMediatorMapper
		{
			return _mappers[matcher.createTypeFilter().descriptor] ||= createMapper(matcher);
		}

		/**
		 * @inheritDoc
		 */
		public function map(type:Class):IMediatorMapper
		{
			return mapMatcher(new TypeMatcher().allOf(type));
		}

		/**
		 * @inheritDoc
		 */
		public function unmapMatcher(matcher:ITypeMatcher):IMediatorUnmapper
		{
			return _mappers[matcher.createTypeFilter().descriptor] || NULL_UNMAPPER;
		}

		/**
		 * @inheritDoc
		 */
		public function unmap(type:Class):IMediatorUnmapper
		{
			return unmapMatcher(new TypeMatcher().allOf(type));
		}

		/**
		 * @inheritDoc
		 */
		public function handleView(view:DisplayObject, type:Class):void
		{
			_handler.handleView(view, type);
		}

		/**
		 * @inheritDoc
		 */
		public function mediate(item:Object):void
		{
			_handler.handleItem(item, item.constructor as Class);
		}

		/**
		 * @inheritDoc
		 */
		public function unmediate(item:Object):void
		{
			_factory.removeMediators(item);
		}
		
		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/
		
		private function createMapper(matcher:ITypeMatcher, viewType:Class = null):IMediatorMapper
		{
			return new StarlingMediatorMapper(matcher.createTypeFilter(), _handler);
		}
	}
}
