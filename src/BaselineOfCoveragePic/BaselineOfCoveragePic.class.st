Class {
	#name : #BaselineOfCoveragePic,
	#superclass : #BaselineOf,
	#category : #BaselineOfCoveragePic
}

{ #category : #baselines }
BaselineOfCoveragePic >> baseline: spec [
	<baseline>
	spec for: #common do: [ | package |
		package := #'Morphic-Test-CoveragePic'.
		spec package: package.
		spec group: #default with: { package }
	].
]
