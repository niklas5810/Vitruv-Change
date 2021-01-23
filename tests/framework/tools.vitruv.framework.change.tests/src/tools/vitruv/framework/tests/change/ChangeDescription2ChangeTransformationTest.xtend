package tools.vitruv.framework.tests.change

import allElementTypes.Root
import java.util.List

import tools.vitruv.framework.change.echange.EChange
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import tools.vitruv.framework.change.recording.AtomicEmfChangeRecorder
import tools.vitruv.framework.util.bridges.EMFBridge
import tools.vitruv.framework.uuid.UuidGeneratorAndResolverImpl
import static extension tools.vitruv.framework.change.echange.resolve.EChangeResolverAndApplicator.*
import tools.vitruv.framework.uuid.UuidGeneratorAndResolver
import tools.vitruv.framework.change.echange.resolve.EChangeUnresolver
import org.eclipse.emf.ecore.resource.ResourceSet
import static extension tools.vitruv.framework.util.ResourceSetUtil.withGlobalFactories
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.AfterEach
import static org.junit.jupiter.api.Assertions.assertEquals
import tools.vitruv.framework.util.bridges.EcoreResourceBridge
import static tools.vitruv.testutils.metamodels.AllElementTypesCreators.aet
import org.eclipse.emf.common.notify.Notifier
import java.util.function.Consumer
import static com.google.common.base.Preconditions.checkState
import org.junit.jupiter.api.^extension.ExtendWith
import tools.vitruv.testutils.TestProjectManager
import tools.vitruv.testutils.TestProject
import java.nio.file.Path
import tools.vitruv.testutils.RegisterMetamodelsInStandalone

@ExtendWith(TestProjectManager, RegisterMetamodelsInStandalone)
abstract class ChangeDescription2ChangeTransformationTest {
	var AtomicEmfChangeRecorder changeRecorder
	var UuidGeneratorAndResolver uuidGeneratorAndResolver
	var ResourceSet resourceSet
	var Path tempFolder
	
	/** 
	 * Create a new model and initialize the change monitoring
	 */
	@BeforeEach
	def void beforeTest(@TestProject Path tempFolder) {
		this.tempFolder = tempFolder
		this.resourceSet = new ResourceSetImpl().withGlobalFactories
		this.uuidGeneratorAndResolver = new UuidGeneratorAndResolverImpl(resourceSet, true)
		this.changeRecorder = new AtomicEmfChangeRecorder(uuidGeneratorAndResolver)
		this.resourceSet.startRecording
	}

	@AfterEach
	def void afterTest() {
		resourceSet.stopRecording
		changeRecorder.dispose()
	}

	protected def <T extends Notifier> record(T objectToRecord, Consumer<T> operationToRecord) {
		resourceSet.stopRecording
		objectToRecord.startRecording
		operationToRecord.accept(objectToRecord)
		objectToRecord.stopRecording
		resourceSet.startRecording
		return prepareChanges
	}

	protected def resourceAt(String name) {
		val tmpFile = tempFolder.resolve('''«name».xmi''')
		val uri = EMFBridge.getEmfFileUriForFile(tmpFile.toFile)
		EcoreResourceBridge.loadOrCreateResource(resourceSet, uri)
	}

	protected def Root getUniquePersistedRoot() {
		val resource = resourceAt("dummy")
		if (resource.contents.empty) {
			val root = aet.Root
			resource.contents += root
			return root
		} else {
			return resource.contents.get(0) as Root
		}
	}

	private def startRecording(Notifier notifier) {
		checkState(!changeRecorder.isRecording)
		this.changeRecorder.addToRecording(notifier)
		this.changeRecorder.beginRecording
	}

	private def stopRecording(Notifier notifier) {
		checkState(changeRecorder.isRecording)
		this.changeRecorder.endRecording
		this.changeRecorder.removeFromRecording(notifier)
	}

	private def List<EChange> prepareChanges() {
		val changeDescriptions = changeRecorder.changes
		val monitoredChanges = changeDescriptions.map[EChanges].flatten
		monitoredChanges.forEach[EChangeUnresolver.unresolve(it)]
		val resultingChanges = newArrayList
		for (change : monitoredChanges.toList.reverseView) {
			resultingChanges += change.resolveAfterAndApplyBackward(this.uuidGeneratorAndResolver)
		}
		resultingChanges.reverse
		for (change : resultingChanges) {
			change.applyForward
		}
		return resultingChanges
	}

	static def assertChangeCount(Iterable<? extends EChange> changes, int expectedCount) {
		assertEquals(
			expectedCount,
			changes.size,
			'''There were «changes.size» changes, although «expectedCount» were expected'''
		)
		return changes
	}

}
