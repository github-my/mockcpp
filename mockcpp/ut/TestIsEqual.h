
#include <cxxtest/TestSuite.h>
#include <Any.h>
#include <IsEqual.h>

using namespace mockcpp;

class TestIsEqual : public CxxTest::TestSuite
{
public:
	void setUp() { }
	void tearDown() { }

	/////////////////////////////////////////////////////////

	void testShouldMatchEqualValue()
	{
		IsEqual<int> isEqual(10);

		TS_ASSERT(isEqual.eval(10));
	}

	void testShouldNotMatchInequalValue()
	{
		IsEqual<int> isEqual(10);

		TS_ASSERT(!isEqual.eval(11));
	}

};

