CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission

if [[ $? -ne 0 ]]
then
    echo 'Issue with github link!'
    exit
else
    echo 'Finished cloning'
fi

if [[ -f student-submission/ListExamples.java ]]
then
    echo 'File found'
else
    echo 'Missing ListExamples.java'
    exit
fi

cp student-submission/ListExamples.java grading-area
cp TestListExamples.java grading-area
cp -r lib grading-area

cd grading-area
javac -cp $CPATH *.java

if [[ $? -ne 0 ]]
then
    echo 'Compilation error. See message above!'
    exit
else
    echo 'Compilation successful'
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

if [[ $? -eq 0 ]]
then
    echo 'All tests passed'
    exit
fi

ERRORS=$(tail -n 2 junit-output.txt)
TOTAL=$(echo "$ERRORS" | cut -d " " -f 3 | rev | cut -c 2- | rev)
FAILURES=$(echo "$ERRORS" | cut -d " " -f 6)
SUCCESSES=$(( $TOTAL - $FAILURES ))
echo "Succeeded:" $SUCCESSES "/" $TOTAL