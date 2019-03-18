package com.jollyclass.shiro.loginshiro.Author;

import java.util.Collection;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.pam.AtLeastOneSuccessfulStrategy;
import org.apache.shiro.realm.Realm;

public class MyAtLeastAuthor extends AtLeastOneSuccessfulStrategy {

	@Override
	public AuthenticationInfo afterAllAttempts(AuthenticationToken token, AuthenticationInfo aggregate)
			throws AuthenticationException {
		return super.afterAllAttempts(token, aggregate);
	}

	@Override
	public AuthenticationInfo beforeAllAttempts(Collection<? extends Realm> realms, AuthenticationToken token)
			throws AuthenticationException {
		return super.beforeAllAttempts(realms, token);
	}

	@Override
	public AuthenticationInfo beforeAttempt(Realm realm, AuthenticationToken token, AuthenticationInfo aggregate)
			throws AuthenticationException {
		return super.beforeAttempt(realm, token, aggregate);
	}

	@Override
	public AuthenticationInfo afterAttempt(Realm realm, AuthenticationToken token, AuthenticationInfo singleRealmInfo,
			AuthenticationInfo aggregateInfo, Throwable t) throws AuthenticationException {
		return super.afterAttempt(realm, token, singleRealmInfo, aggregateInfo, t);
	}

}
