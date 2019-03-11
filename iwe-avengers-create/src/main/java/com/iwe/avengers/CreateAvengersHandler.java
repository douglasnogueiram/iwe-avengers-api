package com.iwe.avengers;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.iwe.avenger.dynamodb.entity.Avenger;
import com.iwe.avenger.lambda.response.HandlerResponse;
import com.iwe.avengers.dao.AvengerDao;

public class CreateAvengersHandler implements RequestHandler<Avenger, HandlerResponse> {

	private AvengerDao dao = new AvengerDao();
	
	@Override
	public HandlerResponse handleRequest(final Avenger newAvenger, final Context context) {

		
		Avenger createdAvenger = null;
		
		context.getLogger().log("[#] - Inicia criacao de avenger...");
		
		createdAvenger = dao.create(newAvenger);
					
		
		final HandlerResponse response = HandlerResponse.builder().setObjectBody(createdAvenger).build();
		
		context.getLogger().log("[#] - Avenger criado: " + createdAvenger.getId());
		
		
		return response;

	}
}
