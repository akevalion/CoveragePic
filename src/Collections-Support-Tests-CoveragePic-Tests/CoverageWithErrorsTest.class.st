Class {
	#name : #CoverageWithErrorsTest,
	#superclass : #TestCase,
	#category : #'Collections-Support-Tests-CoveragePic-Tests'
}

{ #category : #tests }
CoverageWithErrorsTest >> testAssertFalse [
	self assert: false
]

{ #category : #tests }
CoverageWithErrorsTest >> testErrorDivisionByZero [
	1/0
]
