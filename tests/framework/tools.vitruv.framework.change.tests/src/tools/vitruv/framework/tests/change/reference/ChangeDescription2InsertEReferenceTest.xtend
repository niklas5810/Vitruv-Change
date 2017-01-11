package tools.vitruv.framework.tests.change.reference

import allElementTypes.NonRoot
import org.junit.Test

import static extension tools.vitruv.framework.tests.change.util.ChangeAssertHelper.*

class ChangeDescription2InsertEReferenceTest extends ChangeDescription2EReferenceTest {

	@Test
	def public void testInsertEReferenceNonContainment() {
		testInsertInEReference(0)
	}

	@Test
	def public void testMultipleInsertEReferenceNonContainment() {
		testInsertInEReference(0)
		testInsertInEReference(1)
		testInsertInEReference(2)
		testInsertInEReference(1)
	}

	@Test
	def public void testInsertEReferenceContainment() {
		testInsertInContainmentEReference(0)
	}

	@Test
	def public void testMultipleInsertEReferenceContainment() {
		testInsertInContainmentEReference(0)
		testInsertInContainmentEReference(1)
		testInsertInContainmentEReference(2)
		testInsertInContainmentEReference(1)
	}

	def private testInsertInContainmentEReference(int expectedIndex) {
		// prepare
		startRecording
		// test
		val nonRoot = createAndAddNonRootToRootMultiReference(expectedIndex)
		// assert
		assertCreateAndInsertNonRoot(nonRoot, MULTI_VALUED_CONTAINMENT_E_REFERENCE_NAME, expectedIndex)
	}

	def private testInsertInEReference(int expectedIndex) {
		// prepare 
		val nonRoot = createAndAddNonRootToRootMultiReference(expectedIndex)
		startRecording
		// test
		this.rootElement.multiValuedNonContainmentEReference.add(expectedIndex, nonRoot)
		// assert
		val isContainment = false
		assertInsertEReference(nonRoot, MULTI_VALUED_NON_CONTAINMENT_E_REFERENCE_NAME, expectedIndex, isContainment)
	}
	
	def private void assertInsertEReference(NonRoot nonRoot, String featureName, int expectedIndex, boolean isContainment) {
		claimChange(0).assertInsertEReference(this.rootElement, featureName, nonRoot,
			expectedIndex, isContainment)
	}
	
	def private void assertCreateAndInsertNonRoot(NonRoot nonRoot, String featureName, int expectedIndex) {
		claimChange(0).assertCreateAndInsertNonRoot(this.rootElement, featureName, nonRoot,
			expectedIndex)
	}
}
