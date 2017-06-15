<cfscript>

    /* récupération de la config de l'API */
    config = deserializeJson(fileRead(expandPath("./config.json")));

    /* Instantiation */
    instagram = new instagram( access_token=config.access_token );

    /* Récup des photos */
    photos = instagram.callAPI( endpoint="/users/self/media/recent", params={ count=9 } );
    WriteDump(photos);

</cfscript>
