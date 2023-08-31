| classSizeScale classColorCoverage m lbl  env cout file last repoPath actionRepo baseline group tests currentTime category profiler |
env := Smalltalk os environment.
cout := Stdio stdout.
baseline := env at: 'ACTION_BASELINE'.
group := env at: 'ACTION_GROUP'.
tests := env at: 'ACTION_TESTS'.

actionRepo := CommandLineArguments default arguments last asFileReference parent absolutePath pathString.

cout 
    << 'Loading Spy2';
    crlf.
category := 'CoveragePicAction'.
"To remove metacello notifactions"
MetacelloNotification compile: 'defaultAction' classified: category."TODO add a configuration to enable or disable this action"
NewUndeclaredWarning compile: 'defaultAction' classified: category.
MCGitBasedNetworkRepository compile: 'traceCr: aString' classified: category.
ReleaseTest compile: 'testObsoleteClasses' classified: 'tests'.
ReleaseTest compile: 'testPharoVersionFileExists' classified: 'tests'.

currentTime := DateAndTime now.
[

cout << 'Loading spy2 roassal3 and exporters and project'; crlf.

[ Metacello new 
	baseline: 'Spy2'; 
	repository: 'github://ObjectProfile/Spy2'; 
	load: 'HapaoCore' ] on: MCMergeOrLoadWarning do: [:warning | warning load ].

[ Metacello new
    baseline: 'Roassal3';
    repository: 'github://ObjectProfile/Roassal3';
    load: 'Full' ] on: MCMergeOrLoadWarning do: [:warning | warning load ].

[ Metacello new
    baseline: 'Roassal3Exporters';
    repository: 'github://ObjectProfile/Roassal3Exporters';
    load ] on: MCMergeOrLoadWarning do: [:warning | warning load ].

repoPath := 'gitlocal://', (env at: 'GITHUB_WORKSPACE').
cout << 'Clonning from: '; <<  repoPath; crlf.
[Metacello new
	baseline: baseline;
	repository: repoPath;
	load: group ] on: MCMergeOrLoadWarning do: [ :warning | warning load ].
cout << 'Finish baseline `'; << baseline; << '`'; crlf.

currentTime := DateAndTime now.
cout << 'Spy2 has been loaded :V '; crlf; << 'Starting with Hapao'; crlf.

profiler := 'Hapao2' asClass runTestsForPackagesMatching: tests.
cout <<'Profiler created'; crlf.
classSizeScale := 'NSScale' asClass linear range: #(5 30); domain: { 0 . (profiler allClasses max: #numberOfMethods) }.
classColorCoverage := 'NSScale' asClass linear range: {Color red . Color black}; domain: { 0 . 100 }.
m := 'RSMondrian' asClass new.
m shape labeled: #packageName; color: Color white; borderColor: Color gray.
m nodes: profiler packages forEach: [ :pak |
	m shape box 
		size: [ :cls | classSizeScale scale: cls numberOfMethods ];
		color: [ :cls | classColorCoverage scale: cls coverage ];
		if: #isTestClass color: Color green darker.
	m nodes: pak classes.
	m orthoVerticalLine connectFrom: #superclass.
	m layout tidyTree
].
m build.

lbl := RSLabel text: 'Ratio of covered methods = ', (profiler coverage asString), ' %'. 
RSLocation new move: lbl above: m canvas nodes.
m canvas add: lbl.

m canvas extent: (1500 @ 1500).

'RSPNGExporter' asClass new
  canvas: m canvas;
  exportToFile: '/tmp/coverage.png' asFileReference.

out << 'coverage.png created'; crlf.
SmalltalkImage current quitPrimitive


 ] onErrorDo: [:ex | | errorFile |
    errorFile := '/tmp/testError.txt' asFileReference.
    errorFile writeStreamDo: [ :stream | 
        stream
            << ex asString; crlf; 
            << ex signalerContext longStack
    ]
].
cout crlf.
cout << 'Duration: ' << (DateAndTime now - currentTime) humanReadablePrintString.
cout crlf.
SmalltalkImage current quitPrimitive