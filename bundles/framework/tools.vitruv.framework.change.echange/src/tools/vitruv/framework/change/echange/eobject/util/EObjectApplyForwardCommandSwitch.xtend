package tools.vitruv.framework.change.echange.eobject.util

import java.util.Collections
import java.util.List
import org.eclipse.emf.common.command.Command
import org.eclipse.emf.edit.command.AddCommand
import org.eclipse.emf.edit.command.RemoveCommand
import tools.vitruv.framework.change.echange.eobject.CreateEObject
import tools.vitruv.framework.change.echange.eobject.DeleteEObject
import tools.vitruv.framework.change.echange.util.EChangeUtil

/**
 * Switch to create commands for all EChange classes of the eobject package.
 * The commands applies the EChanges forward.
 */
class EObjectApplyForwardCommandSwitch extends EobjectSwitch<List<Command>> {
	private static EObjectApplyForwardCommandSwitch instance;
	
	private new() {}
	
	/**
	 * Gets the singleton of the switch.
	 * @return The singleton instance.
	 */
	public static def EObjectApplyForwardCommandSwitch getInstance() {
		if (instance == null) {
			instance = new EObjectApplyForwardCommandSwitch();
		}
		return instance;
	}
	
	/**
	 * Create commands to apply a {@link CreateEObject} change forward.
	 * @param object The change which commands should be created.
	 */
	override public List<Command> caseCreateEObject(CreateEObject object) {
		val editingDomain = EChangeUtil.getEditingDomain(object.affectedEObject)
		return Collections.singletonList(new AddCommand(editingDomain, object.stagingArea.contents, object.affectedEObject))
	}
	
	/**
	 * Create commands to apply a {@link DeleteEObject} change forward.
	 * @param object The change which commands should be created.
	 */
	override public List<Command> caseDeleteEObject(DeleteEObject object) {
		val editingDomain = EChangeUtil.getEditingDomain(object.affectedEObject)
		return Collections.singletonList(new RemoveCommand(editingDomain, object.stagingArea.contents, object.affectedEObject))
	}
}