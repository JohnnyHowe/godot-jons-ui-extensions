func test_segmentLengthEqualsLineLength_fullFill_noScroll_resultsIn_oneSegment():
	return _get_test_result(
		[[0, 1]],
		ScrollingDashedOutlineRect._get_line_segments_range(1, 1, 1, 0)
	)


func test_segmentLengthEqualsLineLength_halfFill_noScroll_resultsIn_oneSegment():
	return _get_test_result(
		[[0, 0.5]],
		ScrollingDashedOutlineRect._get_line_segments_range(1, 1, 0.5, 0)
	)


func test_smallScroll_resultsIn_boundedSegments():
	return _get_test_result(
		[[0, 0.2], [0.2, 1]],
		ScrollingDashedOutlineRect._get_line_segments_range(1, 1, 1, 0.2)
	)


func _get_test_result(expected: Array[Array], actual: Array[Array]) -> ScriptTestResult:
	return ScriptTestResult.from_equals(
		expected, 
		actual,
		"Items differ",
		_lists_equal_approx
	)


func _lists_equal_approx(expected: Array[Array], actual: Array[Array]) -> bool:
	if expected.size() != actual.size():
		return false

	for i in range(expected.size()):

		if expected[i].size() != actual[i].size():
			return false

		for j in range(expected[i].size()):
			if not is_equal_approx(expected[i][j], actual[i][j]):
				return false

	return true 


