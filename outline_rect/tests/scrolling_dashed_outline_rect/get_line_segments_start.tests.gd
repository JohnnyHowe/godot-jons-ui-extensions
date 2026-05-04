func test_segmentLengthEqualsLineLength_noScroll_resultsIn_oneSegment():
	return _get_test_result(
		[0.0],
		ScrollingDashedOutlineRect._get_line_segments_start(1, 1, 0),
	)


func test_segmentLengthEqualsLineLength_halfScroll_resultsIn_twoSegments():
	return _get_test_result(
		[-0.5, 0.5],
		ScrollingDashedOutlineRect._get_line_segments_start(1, 1, 0.5),
	)


func test_nonFactorSegment_noScroll_resultsIn_twoSegments():
	return _get_test_result(
		[0.0, 0.6],
		ScrollingDashedOutlineRect._get_line_segments_start(1, 0.6, 0),
	)


func test_nonFactorSegment_smallScroll_resultsIn_twoSegments():
	return _get_test_result(
		[-0.4, 0.2, 0.8],
		ScrollingDashedOutlineRect._get_line_segments_start(1, 0.6, 0.2),
	)


func test_nonFactorSegment_scrollAlmostSegmentSize_resultsIn_twoSegments():
	return _get_test_result(
		[-0.1, 0.5],
		ScrollingDashedOutlineRect._get_line_segments_start(1, 0.6, 0.5)
	)


func _get_test_result(expected: Array, actual: Array) -> ScriptTestResult:
	return ScriptTestResult.from_equals(
		expected, 
		actual,
		"Items differ",
		_lists_equal_approx
	)


func _lists_equal_approx(expected: Array, actual: Array) -> bool:
	if expected.size() != actual.size():
		return false

	for i in range(expected.size()):
		if not is_equal_approx(expected[i], actual[i]):
			return false

	return true 
