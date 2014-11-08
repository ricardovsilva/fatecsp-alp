unit ProductUtilsTests;
interface
  function RemoveVerifierDigitTest : boolean;
implementation

	uses
		ProductUtils,
		TestUtils;

	function RemoveVerifierDigitTest : boolean;
	var
		expected, actual, target : string;
	begin
		target := '1234-5';
		expected := '1234';
		actual := RemoveVerifierDigit(target);

		RemoveVerifierDigitTest := AssertString(expected, actual, 'ProductUtilsTests.RemoveVerifierDigitTest');
	end;
end.