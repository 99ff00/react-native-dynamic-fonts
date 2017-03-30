/**
 * Copyright (c) 2017-present, Wyatt Greenway. All rights reserved.
 *
 * This source code is licensed under the MIT license found in the LICENSE file in the root
 * directory of this source tree.
 */
 
const { NativeModules } = require('react-native');
const { DynamicFonts } = NativeModules;

module.exports = {
	loadFont: function(name, data, _type) {
		if (!name)
			throw new Error('Name is a required argument');

		if (!data)
			throw new Error('Data is a required argument');

		return new Promise(function(resolve, reject) {
			DynamicFonts.loadFont({
				name: name,
				data: data,
				type: type
			}, function(err, givenName) {
				if (err) {
					reject(err);
					return;
				}

				resolve(givenName);
			});
		});
	}
}