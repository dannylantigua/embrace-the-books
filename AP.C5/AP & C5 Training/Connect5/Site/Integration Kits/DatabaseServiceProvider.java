package com.agencyport.training.service;

import com.agencyport.service.BuiltinVariableNames;
import com.agencyport.service.Provider;
import com.agencyport.service.Response;
import com.agencyport.service.ServiceException;
import com.agencyport.service.security.User;
import com.agencyport.service.text.StringUtilities;

/**
 * The DatabaseService class provides access to C5 database for querying states for cities.
 */
public class DatabaseServiceProvider extends Provider {
	
	private final String STATE_ABBR = "STATE_ABBR";	
	
	/**
	 * Constructs an instance.
	 */
	public DatabaseServiceProvider(){
	}
	
	/**
	 * Constructs an instance accepting the current user.
	 * @param currentUser is the current user.
	 */
	public DatabaseServiceProvider(User currentUser){
		super(currentUser);
	}
	
	/**
	 * Gets a set of cities for the given state abbr.
	 * @param state is the controlling state.
	 * @return a Response instance containing the cities.
	 * @throws ServiceException if the retrieval of the cities failed.
	 */
	public Response getCities(String state) throws ServiceException {
		this.variables.put(BuiltinVariableNames.ACTION, "getCities");
		
		this.modifySuffixOnProviderId("getCities");
		
		if (!StringUtilities.isEmptyOnTrim(state)){
			this.variables.put(STATE_ABBR, state);
		}
		
		return invoke();
	}	
}
