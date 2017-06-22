/**
 * @author Patrick Pézier - http://patrick.pezier.com
 * Composant ColdFusion communiquant avec l'API Instagram
 * URL : https://www.instagram.com/developer/
 */
component
	accessors="true"
	output="false"
	{

		/* encodage */
		pageencoding "utf-8";

		/* propriétés */
		property name="accessToken"	type="string"; // access token OAuth 2.0

		/* constantes */
		this.API_URL = "https://api.instagram.com/v1"; // url racine de l'API


		/**
		 * constructeur
		 */
		public instagram function init( string access_token="" ){
			this.setAccessToken(arguments.access_token);
			return(this);
		}


		/**
		 * Appelle l'API
		 * @endPoint.hint	endpoint demandé
		 * @params.hint		struct de paramètres
		 * @method.hint		méthode (seule GET est implémentée)
		 */
		public any function callAPI( string endPoint="", struct params={}, string method="GET" ){

			/* préparation de l'appel à l'API Instagram */
			var httpService = new http(
				method	= "#arguments.method#",
				charset	= "utf-8",
				timeout	= 15 // secondes
			);
			httpService.setUrl(this.API_URL & endpoint);
			httpService.addParam(type="URL", name="access_token", value="#this.getAccessToken()#");

			/* ajout des paramètres en fonction de la méthode */
			switch(uCase(method)){

				case "GET":
					for (structkey in arguments.params)
						httpService.addParam(type="URL", name="#lCase(structkey)#", value="#structFind(arguments.params,structkey)#");
				break;

				case "POST": case "DEL":
				break;

				default:
					return( "Erreur : Méthode non prise en charge par l'API." );
				break;

			} // fin switch

			/* appel de l'API */
			try {
				var result = httpService.send().getPrefix();
			} catch(any e) {
				return( "Erreur de requête http : " & e.message );
			}

			/**
			 * vérification du contenu renvoyé
			 */
			if (val(result.statusCode) neq 200) // le serveur a répondu avec un code invalide
				return( "Erreur de réponse HTTP : " & result.statusCode );
			else if (not isJSON(result.fileContent)) // la réponse n'est pas au format JSON
				return( "Erreur de format de réponse" );

			/**
			 * traitement du contenu renvoyé
			 */
			json = deserializeJSON(result.fileContent);
			if (val(json.meta.code) neq 200) // le JSON contient un code d'erreur
				return( "Erreur de réponse JSON: " & json.meta.error_message );
			else // tout s'est bien passé
				return( json );

		} // fin function callAPI


	}
