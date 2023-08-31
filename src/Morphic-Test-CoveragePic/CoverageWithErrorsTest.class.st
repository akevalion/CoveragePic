Class {
	#name : #CoverageWithErrorsTest,
	#superclass : #TestCase,
	#category : #'Morphic-Test-CoveragePic'
}

{ #category : #tests }
CoverageWithErrorsTest >> testAssertFalse [
	self assert: false
]

{ #category : #tests }
CoverageWithErrorsTest >> testErrorDivisionByZero [
	1/0
]
