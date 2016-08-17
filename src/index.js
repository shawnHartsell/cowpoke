const hyped = require( "hyped" )( {} );
const autohost = require( "autohost" );
const config = require( "./config" );
const fount = require( "fount" );

if ( !config.docker.user || !config.docker.pass ) {
	throw new Error( "DOCKER_PASS or DOCKER_USER is not defined" );
}

if ( !config.github.token || !config.github.owner ) {
	throw new Error( "GITHUB_TOKEN or GITHUB_OWNER is not defined" );
}

const environmentRepo = require( "./data/nedb/environment" );
fount.register( "environment", environmentRepo );

const slack = require( "./slack" )( config.slack.token, environmentRepo );
fount.register( "slack", slack );

const dockerhub = require( "./dockerhub" )(config.docker.user, config.docker.pass);
fount.register( "dockerhub", dockerhub );
fount.register( "github", config.github );

const host = hyped.createHost( autohost, {
	port: config.host.port,
	fount: fount,
	noSession: true,
	session: null,
	handleRouteErrors: true
} );

host.start();
