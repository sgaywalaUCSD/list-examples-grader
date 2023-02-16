CPATH=".;../lib/junit-4.13.2.jar;../lib/hamcrest-core-1.3.jar"

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

if [[ -f "student-submission/ListExamples.java" ]]
then
    echo 'Found ListExamples.java'
else
    echo 'ListExamples.java not found'
    exit 1
fi 

cp TestListExamples.java student-submission/

cd student-submission

javac ListExamples.java
if [[ -f "StringChecker.class" ]] && [[ -f "ListExamples.class" ]]
then
    echo "Student files compiled succesfully"
else
    echo "Student fies failed to compile"
    exit 2
fi

javac -cp ".;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar" *.java
java -cp ".;../lib/junit-4.13.2.jar;../lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples


java -cp $CPATH org.junit.runner.JUnitCore student-submission/*.java > output.txt

grep "Tests run" output.txt > grepResults.txt

TESTSRUN=` cut -d ',' -f 1 grepResults.txt `

FAILURES=` cut -d ',' -f 2 grepResults.txt `

NUMFAILURES="${FAILURES//[^0-9]/}"
echo $NUMFAILURES

NUMTESTS="${TESTSRUN//[^0-9]/}"
echo $NUMTESTS
