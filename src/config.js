const configya = require("configya");
const fs = require("fs");
const path = require("path");
const _ = require("lodash");
const configPrefix = process.env.COWPOKE_CONFIG_PREFIX || "";

function getDefaultData() {
	const dataFiles = [path.join(__dirname, "../config.defaults.json")];

	if (process.NODE_ENV === "local") {
		dataFiles.push(path.join(__dirname, "../config.json"));
	}

	const [defaultData, localData] = dataFiles.map( file => {
		return fs.statSync( file ) ? JSON.parse( fs.readFileSync( file, "utf-8" ) ) : {};
	} );

	const defaults = _.merge(defaultData, localData);
	//explitly set the nedb path here, but do it in a way that makes it overridable by env var
	defaults.nedb = {path: path.join(__dirname, "../data")};
	return defaults;
}

module.exports  = configya({
	prefix: configPrefix,
	defaults: getDefaultData()
});
