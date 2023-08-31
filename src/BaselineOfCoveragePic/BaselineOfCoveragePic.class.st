Class {
	#name : #BaselineOfCoveragePic,
	#superclass : #BaselineOf,
	#category : #BaselineOfCoveragePic
}

{ #category : #baselines }
BaselineOfCoveragePic >> baseline: spec [
	<baseline>
	spec for: #common do: [ | package |
		package := #'Collections-Support-Tests-CoveragePic-Tests'.
		spec package: package.
		spec group: #default with: { package }
	].
]
