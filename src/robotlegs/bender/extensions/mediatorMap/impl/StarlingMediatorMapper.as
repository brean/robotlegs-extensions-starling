//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.mediatorMap.api.IStarlingMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.api.IStarlingMediatorViewHandler;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingConfig;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * @private
	 */
	public class StarlingMediatorMapper implements IMediatorMapper, IMediatorUnmapper
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings:Dictionary = new Dictionary();

		private var _typeFilter:ITypeFilter;

		private var _handler:IStarlingMediatorViewHandler;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function StarlingMediatorMapper(typeFilter:ITypeFilter, handler:IStarlingMediatorViewHandler, logger:ILogger = null)
		{
			_typeFilter = typeFilter;
			_handler = handler;
			_logger = logger;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function toMediator(mediatorClass:Class):IMediatorMappingConfig
		{
			const mapping:IStarlingMediatorMapping = _mappings[mediatorClass];
			return mapping
				? overwriteMapping(mapping)
				: createMapping(mediatorClass);
		}

		/**
		 * @inheritDoc
		 */
		public function fromMediator(mediatorClass:Class):void
		{
			const mapping:IStarlingMediatorMapping = _mappings[mediatorClass];
			mapping && deleteMapping(mapping);
		}

		/**
		 * @inheritDoc
		 */
		public function fromAll():void
		{
			for each (var mapping:IStarlingMediatorMapping in _mappings)
			{
				deleteMapping(mapping);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createMapping(mediatorClass:Class):StarlingMediatorMapping
		{
			const mapping:StarlingMediatorMapping = new StarlingMediatorMapping(_typeFilter, mediatorClass);
			_handler.addMapping(mapping);
			_mappings[mediatorClass] = mapping;
			_logger && _logger.debug('{0} mapped to {1}', [_typeFilter, mapping]);
			return mapping;
		}

		private function deleteMapping(mapping:IStarlingMediatorMapping):void
		{
			_handler.removeMapping(mapping);
			delete _mappings[mapping.mediatorClass];
			_logger && _logger.debug('{0} unmapped from {1}', [_typeFilter, mapping]);
		}

		private function overwriteMapping(mapping:IStarlingMediatorMapping):IMediatorMappingConfig
		{
			_logger && _logger.warn('{0} already mapped to {1}\n' +
				'If you have overridden this mapping intentionally you can use "unmap()" ' +
				'prior to your replacement mapping in order to avoid seeing this message.\n',
				[_typeFilter, mapping]);
			deleteMapping(mapping);
			return createMapping(mapping.mediatorClass);
		}
	}
}
