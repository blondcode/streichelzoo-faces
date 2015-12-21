package de.katerkamp;

import java.io.Serializable;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Logger;
import javax.enterprise.context.RequestScoped;
import javax.enterprise.context.SessionScoped;
import javax.faces.component.UIViewRoot;

import javax.faces.context.FacesContext;
import javax.faces.event.ValueChangeEvent;
import javax.inject.Inject;
import javax.inject.Named;
 
@Named("language")
@RequestScoped

public class LanguageBean implements Serializable{
	
	private static final long serialVersionUID = 1L;

 	//@Inject
    //private MySessionScopedBean mybean;
	
	//@Inject
    //FacesContext facesContext;
	
	private static final Logger logger = Logger.getLogger(LanguageBean.class.getName());
	FacesContext facesContext = FacesContext.getCurrentInstance();
	private Locale locale = Locale.GERMANY;
	private Map<String,Locale> availableLanguages;
	private String language;

	private List<Locale> availableLocales;

	LanguageBean() {
		UIViewRoot viewRoot = facesContext.getViewRoot();
		if (viewRoot != null) {
			locale = viewRoot.getLocale();
			logger.warning("Locale set: " + locale);
		}
		logger.warning("Locale is: " + locale);
		initAvailableLanguageMap();
	}

	void initAvailableLanguageMap() {
		availableLanguages = new LinkedHashMap<>();
		availableLanguages.put(Locale.ENGLISH.getDisplayLanguage(locale), Locale.ENGLISH);
		availableLanguages.put(Locale.GERMAN.getDisplayLanguage(locale), Locale.GERMAN);
		availableLocales = new LinkedList<>();
		availableLocales.add(Locale.ENGLISH);
		availableLocales.add(Locale.GERMAN);
	}

	/* TODO Fix: Must evaluate to String, Object (not Locale) */
	public Map<String, Locale> getLanguages() {
		return availableLanguages;
	}

	public List<Locale> getLocales() {
		return availableLocales;
	}

	public String getLanguage() {
		if (language == null) {
			return "LanguageUndef";
		}
		return language;
	}

	public void setLanguage(String language) {
		logger.warning("Language is now: " + language);
		this.language = language;
	}
	

	public Locale getLocale() {
		return locale;
	}

	public void setLocale(Locale locale) {
		this.locale = locale;
	}

	int code;

	public int getCode() {
		return code;
	}
	public void setCode(int hashCode) {
		logger.warning("Code is now: " + hashCode);
	}

	public void countryLocaleCodeChanged(ValueChangeEvent e){
		
		Object v = e.getNewValue();
		logger.warning("Locale is now: " + v);
		if (e != null) {
		logger.warning("Locale is instance of: " + e.getNewValue().getClass().getName());
		Locale newLocale = Locale.forLanguageTag(e.getNewValue().toString());
		}
		
		/*
        for (Map.Entry<String, Locale> entry : availableLanguages.entrySet()) {
        	if(entry.getValue().equals(newLocale)){
				FacesContext.getCurrentInstance().getViewRoot().setLocale(newLocale);
			} 
        }
				*/

	}

}