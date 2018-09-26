package com.iwe.avengers;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.iwe.avenger.dynamodb.entity.Avenger;
import com.iwe.avenger.lambda.response.HandlerResponse;
import com.iwe.avengers.dao.AvengerDao;
import com.iwe.avengers.exception.AvengerNotFoundException;

public class RemoveAvengerHandler implements RequestHandler<Avenger, HandlerResponse> {

	private AvengerDao dao = new AvengerDao();
	
	@Override
	public HandlerResponse handleRequest(final Avenger avenger, final Context context) {

		
		
		context.getLogger().log("[#] - Searching avenger by id " + avenger.getId());
		
		if(dao.search(avenger.getId()) != null) {
			
			context.getLogger().log("[#] - Avenger found, deleting...");
			
			dao.delete(avenger);
			
			context.getLogger().log("[#] - Avenger sucessfully deleted...");
		}
		else {
			
			context.getLogger().log("[#] - Avenger not found - trying to delete...");
			throw new AvengerNotFoundException("[NotFound] - Avenger id: " + avenger.getId());
		}
		
		final HandlerResponse response = HandlerResponse.builder().setObjectBody(avenger).build();
		
		
		return response;
		
		
	}
}
