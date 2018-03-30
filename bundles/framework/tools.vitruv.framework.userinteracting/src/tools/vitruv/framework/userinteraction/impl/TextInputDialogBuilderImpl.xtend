package tools.vitruv.framework.userinteraction.impl

import tools.vitruv.framework.userinteraction.TextInputDialogBuilder
import tools.vitruv.framework.userinteraction.impl.TextInputDialog.InputValidator
import org.eclipse.swt.widgets.Shell
import org.eclipse.swt.widgets.Display
import java.util.function.Function
import tools.vitruv.framework.userinteraction.InputFieldType

/**
 * Builder class for {@link TextInputDialog}s. Use the add/set... methods to specify details and then call
 * createAndShow() to display and get a reference to the configured dialog.
 * Creates a dialog with a text input field (configurable to accept single or multi-line input). A {@link InputValidator}
 * can also be specified which limits the input to strings conforming to its
 * {@link InputValidator#isInputValid(String) isInputValid} method (the default validator accepts all input).<br>
 * <br>
 * For further info on the rationale behind the ...DialogBuilder implementation, see the {@link DialogBuilder} javadoc.
 * @see TextInputDialogBuilder
 * 
 * @author Dominik Klooz
 */
class TextInputDialogBuilderImpl extends BaseDialogBuilder<String> implements TextInputDialogBuilder,
        TextInputDialogBuilder.OptionalSteps {
    private TextInputDialog dialog
    private InputFieldType inputFieldType = InputFieldType.SINGLE_LINE
    private InputValidator inputValidator = TextInputDialog.ACCEPT_ALL_INPUT_VALIDATOR
    
    new(Shell shell, Display display) {
        super(shell, display)
        title = "Input Text..."
    }
    
    override message(String message) {
        this.message = message
        return this
    }
    
    override inputValidator(InputValidator inputValidator) {
        this.inputValidator = inputValidator
        return this
    }
    
    override inputValidator(Function<String, Boolean> validatorFunction, String invalidInputMessage) {
        this.inputValidator = new InputValidator() {
            override getInvalidInputMessage(String input) { invalidInputMessage }
            override isInputValid(String input) { validatorFunction.apply(input) }
        }
        return this
    }
    
    override inputFieldType(InputFieldType inputFieldType) {
        this.inputFieldType = inputFieldType
        return this
    }

    override def String showDialogAndGetUserInput() {
        dialog = new TextInputDialog(shell, windowModality, title, message, inputFieldType, inputValidator)
        openDialog()
        return dialog.input
    }
    
}
