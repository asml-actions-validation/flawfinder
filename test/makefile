# Flawfinder.
# Released under the General Public License (GPL) version 2 or later.
# (C) 2001-2017 David A. Wheeler.

PYTHON=python3
FLAWFINDER=../flawfinder.py
SETUPPY=../setup.py

test_001: $(FLAWFINDER) test.c test2.c
	@echo 'test_001 (text output)'
	@# Omit time report so that results are always the same textually.
	@$(PYTHON) $(FLAWFINDER) --omittime test.c test2.c > test-results.txt
	@echo >> test-results.txt
	@echo "Testing for no ending newline:" >> test-results.txt
	@$(PYTHON) $(FLAWFINDER) --omittime no-ending-newline.c | \
	  grep 'Lines analyzed' >> test-results.txt
	@diff -u correct-results.txt test-results.txt

test_002: $(FLAWFINDER) test.c test2.c
	@echo 'test_002 (HTML output)'
	@$(PYTHON) $(FLAWFINDER) --omittime --html --context test.c test2.c > test-results.html
	@diff -u correct-results.html test-results.html

test_003: $(FLAWFINDER) test.c test2.c
	@echo 'test_003 (CSV output)'
	@$(PYTHON) $(FLAWFINDER) --csv test.c test2.c > test-results.csv
	@diff -u correct-results.csv test-results.csv

test_004: $(FLAWFINDER) test.c
	@echo 'test_004 (single-line)'
	@$(PYTHON) $(FLAWFINDER) -m 5 -S -DC --quiet test.c > \
	  test-results-004.txt
	@diff -u correct-results-004.txt test-results-004.txt

test_005: $(FLAWFINDER) test-diff-005.patch test-patched.c
	@echo 'test_005 (diff)'
	@$(PYTHON) $(FLAWFINDER) -SQDC -P test-diff-005.patch \
	  test-patched.c > test-results-005.txt
	@diff -u correct-results-005.txt test-results-005.txt

test_006: $(FLAWFINDER) test.c
	@echo 'test_006 (save/load hitlist)'
	@$(PYTHON) $(FLAWFINDER) -S -DC --quiet \
	  --savehitlist test-saved-hitlist-006.txt \
	  test.c > test-junk-006.txt
	@$(PYTHON) $(FLAWFINDER) -SQDC -m 5 \
	  --loadhitlist test-saved-hitlist-006.txt > \
	  test-results-006.txt
	@diff -u correct-results-006.txt test-results-006.txt

test_007: $(SETUPPY)
	@echo 'test_007 (setup.py sane)'
	@test "`$(PYTHON) $(SETUPPY) --name`" = 'flawfinder'
	@test "`$(PYTHON) $(SETUPPY) --license`" = 'GPL-2.0+'
	@test "`$(PYTHON) $(SETUPPY) --author`" = 'David A. Wheeler'

test_008: $(FLAWFINDER) test.c
	@echo 'test_008 (diff hitlist)'
	@$(PYTHON) $(FLAWFINDER) -S -DC --quiet \
	  --savehitlist test-saved-hitlist-008.txt \
	  test.c > test-junk-008.txt
	@$(PYTHON) $(FLAWFINDER) -S -C --quiet --omittime \
	  --diffhitlist  test-saved-hitlist-008.txt test.c > \
	  test-results-008.txt
	@diff -u correct-results-008.txt test-results-008.txt

test_009: $(FLAWFINDER) test-cpp-digit-separator.cpp test-cpp-digit-separator.c
	@echo 'test_009 (digit separator in numeric literals)'
# Both C++ and C files should handle ' as a digit separator without error,
# since C23 added digit separators and flawfinder cannot determine which
# C standard version is in use.
	@$(PYTHON) $(FLAWFINDER) test-cpp-digit-separator.cpp > /dev/null
	@$(PYTHON) $(FLAWFINDER) test-cpp-digit-separator.c > /dev/null

test_010: $(FLAWFINDER) test-boost-system.hpp
	@echo 'test_010 (system:: ignored)'
	@$(PYTHON) $(FLAWFINDER) --error-level 2 test-boost-system.hpp \
	  > /dev/null

test_011: $(FLAWFINDER) test-cxx-stl.cpp
	@echo 'test_011 (C++ STL false-positive fixes)'
# enum members and std::ranges:: versions must not warn; legacy 3-iterator
# forms must still warn.
	@$(PYTHON) $(FLAWFINDER) --omittime -m 1 -DC --quiet \
	  test-cxx-stl.cpp > test-results-011.txt
	@diff -u correct-results-011.txt test-results-011.txt

test_012: $(FLAWFINDER) test-modern-cpp.cpp
	@echo 'test_012 (modern C++ lexing: binary/hex literals, hex floats, digit separators)'
# Modern C++ syntax must produce zero hits (no false positives from the lexer).
	@$(PYTHON) $(FLAWFINDER) --omittime -m 1 -DC --quiet \
	  test-modern-cpp.cpp > test-results-012.txt
	@diff -u correct-results-012.txt test-results-012.txt

# Run all tests on *one* version of Python;
# output shows differences from expected results.
# If everything works as expected, it just prints test numbers.
# Set PYTHON as needed, including to ""
test: test_001 test_002 test_003 test_004 test_005 test_006 test_007 test_008 \
	  test_009 test_010 test_011 test_012
	@echo 'All tests pass!'

check: test

# Run "make test-is-correct" if the results are as expected.
test-is-correct: test-results.txt
	cp -p test-results.txt correct-results.txt
	cp -p test-results.html correct-results.html
	cp -p test-results.csv correct-results.csv
	cp -p test-results-004.txt correct-results-004.txt
	cp -p test-results-005.txt correct-results-005.txt
	cp -p test-results-006.txt correct-results-006.txt
	cp -p test-results-008.txt correct-results-008.txt
	cp -p test-results-011.txt correct-results-011.txt
	cp -p test-results-012.txt correct-results-012.txt

.PHONY: test check test-is-correct
