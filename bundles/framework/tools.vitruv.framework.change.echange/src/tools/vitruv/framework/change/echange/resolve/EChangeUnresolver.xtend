package tools.vitruv.framework.change.echange.resolve

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import tools.vitruv.framework.change.echange.compound.CompoundEChange
import tools.vitruv.framework.change.echange.compound.ExplicitUnsetEFeature
import tools.vitruv.framework.change.echange.eobject.EObjectAddedEChange
import tools.vitruv.framework.change.echange.eobject.EObjectExistenceEChange
import tools.vitruv.framework.change.echange.eobject.EObjectSubtractedEChange
import tools.vitruv.framework.change.echange.feature.FeatureEChange
import tools.vitruv.framework.change.echange.feature.reference.InsertEReference
import tools.vitruv.framework.change.echange.feature.reference.RemoveEReference
import tools.vitruv.framework.change.echange.feature.reference.ReplaceSingleValuedEReference
import tools.vitruv.framework.change.echange.root.InsertRootEObject
import tools.vitruv.framework.change.echange.root.RemoveRootEObject
import tools.vitruv.framework.change.echange.root.RootEChange
import tools.vitruv.framework.change.echange.AtomicEChange
import tools.vitruv.framework.change.echange.EChange
import tools.vitruv.framework.change.echange.eobject.DeleteEObject
import tools.vitruv.framework.change.echange.eobject.CreateEObject

/**
 * Utility class to unresolve a given EChange.
 */
public class EChangeUnresolver {
	private new() {}
	
	/**
	 * Unresolves the attributes of the {@link RootEChange} class.
	 * @param The RootEChange.
	 */
	def static public unresolveRootEChange(RootEChange change) {
		change.resource = null
	}
	
	/**
	 * Unresolves the attributes of the {@link FeatureEChange} class.
	 * @param The FeatureEChange.
	 */
	def static public <A extends EObject, F extends EStructuralFeature> void unresolveFeatureEChange(FeatureEChange<A,F> change) {
		change.affectedEObject = null
	}
	
	/** 
	 * Unresolves the attributes of the {@link EObjectAddedEChange} class.
	 * @param The EObjectAddedEChange.
	 */
	def static public <T extends EObject> void unresolveEObjectAddedEChange(EObjectAddedEChange<T> change) {
		change.newValue = null
	}	

	/** 
	 * Unresolves the attributes of the {@link EObjectExistenceEChange} class.
	 * @param The EObjectExistenceEChange.
	 */	
	def static public <T extends EObject> void unresolveEObjectExistenceEChange(EObjectExistenceEChange<T> change) {
		change.affectedEObject = null
	}
	
	/** 
	 * Unresolves the attributes of the {@link EObjectSubtractedEChange} class.
	 * @param The EObjectSubtractedEChange.
	 */	
	def static public <T extends EObject> void unresolveEObjectSubtractedEChange(EObjectSubtractedEChange<T> change) {
		change.oldValue = null
	}

	/** 
	 * Unresolves the atomic changes of the {@link CompoundEChange} class.
	 * @param The CompoundEChange.
	 */		
	def static public void unresolveCompoundEChange(CompoundEChange change) {
		for (AtomicEChange c : change.atomicChanges) {
			c.unresolve
		}		
	}
	
	/** 
	 * Unresolves the attributes of the {@link ExplicitUnsetEFeature} class.
	 * @param The ExplicitUnsetEFeature change.
	 */		
	def static public <A extends EObject, F extends EStructuralFeature> void unresolveExplicitUnsetEFeature(ExplicitUnsetEFeature<A, F> change) {
		change.affectedEObject = null
	}
	
	def dispatch public static void unresolve(EChange change) {
	}
	
	/**
	 * Dispatch method for {@link CompoundEChange} to unresolve it.
	 * @param change The CompoundEChange.
	 */	
	def dispatch public static void unresolve(CompoundEChange change) {
		change.unresolveCompoundEChange
	}
	/**
	 * Dispatch method for {@link ExplicitUnsetEFeature} to unresolve it.
	 * @param change The ExplicitUnsetEFeature.
	 */	
	def dispatch public static void unresolve(ExplicitUnsetEFeature<EObject, EStructuralFeature> change) {
		change.unresolveExplicitUnsetEFeature
		change.unresolveCompoundEChange
	}
	/**
	 * Dispatch method for {@link InsertRootEObject} to unresolve it.
	 * @param change The InsertRootEObject.
	 */	
	def dispatch public static void unresolve(InsertRootEObject<EObject> change) {
		change.unresolveRootEChange
		change.newValue = null
	}	
	/**
	 * Dispatch method for {@link RemoveRootEObject} to unresolve it.
	 * @param change The RemoveRootEObject.
	 */
	def dispatch public static void unresolve(RemoveRootEObject<EObject> change) {
		change.unresolveRootEChange
		change.oldValue = null
	}
	/**
	 * Dispatch method for {@link CreateEObject} to unresolve it.
	 * @param change The CreateEObject change.
	 */	
	def dispatch public static void unresolve(CreateEObject<EObject> change) {
		change.unresolveEObjectExistenceEChange
	}
	/**
	 * Dispatch method for {@link DeleteEObject} to unresolve it.
	 * @param change The DeleteEObject change.
	 */	
	def dispatch public static void unresolve(DeleteEObject<EObject> change) {
		change.unresolveEObjectExistenceEChange
		change.consequentialRemoveChanges.forEach[unresolve];
	}
	/**
	 * Dispatch method for {@link ReplaceSingleValuedEReference} to unresolve it.
	 * @param change The ReplaceSingleValuedEReference.
	 */	
	def dispatch public static void unresolve(ReplaceSingleValuedEReference<EObject, EObject> change) {
		change.unresolveEObjectAddedEChange
		change.unresolveEObjectSubtractedEChange
		change.unresolveFeatureEChange
	}
	
	/**
	 * Dispatch method for {@link InsertEReference} to unresolve it.
	 * @param change The InsertEReference.
	 */	
	def dispatch public static void unresolve(InsertEReference<EObject, EObject> change) {
		change.unresolveEObjectAddedEChange
		change.unresolveFeatureEChange		
	}
	
	/**
	 * Dispatch method for {@link RemoveEReference} to unresolve it.
	 * @param change The RemoveEReference.
	 */	
	def dispatch public static void unresolve(RemoveEReference<EObject, EObject> change) {
		change.unresolveEObjectSubtractedEChange
		change.unresolveFeatureEChange		
	}
	
	/**
	 * Dispatch method for {@link FeatureEChange} to unresolve it.
	 * @param change The FeatureEChange.
	 */
	def dispatch public static void unresolve(FeatureEChange<EObject, EStructuralFeature> change) {
		change.unresolveFeatureEChange
	}
}