package tools.vitruv.change.composite.description.impl;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

import org.eclipse.emf.ecore.EObject;

import tools.vitruv.change.atomic.EChange;
import tools.vitruv.change.atomic.hid.AtomicEChangeFilterResolver;
import tools.vitruv.change.atomic.hid.AtomicEChangeHierarchicalIdResolver;
import tools.vitruv.change.atomic.hid.HierarchicalId;
import tools.vitruv.change.composite.description.VitruviusChange;

public class VitruviusChangeFilterResolver extends AbstractVitruviusChangeResolver<EObject> {
	
	private AtomicEChangeFilterResolver atomicChangeResolver;

	public VitruviusChangeFilterResolver(AtomicEChangeFilterResolver atomicChangeResolver) {
		this.atomicChangeResolver = atomicChangeResolver;
	}

	
	@Override
	public VitruviusChange<EObject> resolveAndApply(VitruviusChange<EObject> change) {
		applyBackward(change);
		VitruviusChange<EObject> result = transformVitruviusChange(change, atomicChangeResolver::applyForwardAndMapToObject, transactionalChange -> {});
		/**
		 * TODO: the correct handling would be to call endTransaction() each time after
		 * a transactional change is applied forward or backward. Due to incomplete
		 * change recording (https://github.com/vitruv-tools/Vitruv-Change/issues/71)
		 * this would result in failures when handling a composite change with multiple
		 * transactional changes as containment information of cascade deleted elements
		 * would be lost.
		 */
		atomicChangeResolver.endTransaction();
		return result;
	}
	
	@Override
	public VitruviusChange<EObject> assignIds(VitruviusChange<EObject> change) {
		// TODO Auto-generated method stub
		return null;
	}

	
	private void applyBackward(VitruviusChange<EObject> change) {
		if (change instanceof CompositeContainerChangeImpl<EObject> compositeChange) {
			List<VitruviusChange<EObject>> changes = new LinkedList<>(compositeChange.getChanges());
			Collections.reverse(changes);
			changes.forEach(this::applyBackward);
		} else if (change instanceof TransactionalChangeImpl<EObject> transactionalChange) {
			List<EChange<EObject>> changes = new LinkedList<>(transactionalChange.getEChanges());
			Collections.reverse(changes);
			changes.forEach(atomicChangeResolver::applyBackward);
		} else {
			throw new IllegalStateException(
					"trying to apply unknown change of class " + change.getClass().getSimpleName());
		}
	}







}
