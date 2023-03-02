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

javac -cp $CPATH *.java
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples


java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > output.txt

tail -n 2 output.txt | head -n 1 > grepResults.txt

if grep -q "OK" grepResults.txt;
then   
    echo "Passed all tests"
else
    TESTSRUN=` cut -d ',' -f 1 grepResults.txt `

    FAILURES=` cut -d ',' -f 2 grepResults.txt `

    NUMFAILURES="${FAILURES//[^0-9]/}"

    NUMTESTS="${TESTSRUN//[^0-9]/}"

    PASSEDTESTS=`expr $NUMTESTS - $NUMFAILURES`
    echo $PASSEDTESTS

    SCORE=`expr $PASSEDTESTS / $NUMTESTS`
    echo "your score is: " $SCORE "%"
fi

# grep "Tests run" output.txt > grepResults.txt

# TESTSRUN=` cut -d ',' -f 1 grepResults.txt `

# FAILURES=` cut -d ',' -f 2 grepResults.txt `

# NUMFAILURES="${FAILURES//[^0-9]/}"
# echo $NUMFAILURES

# NUMTESTS="${TESTSRUN//[^0-9]/}"
# echo $NUMTESTS

