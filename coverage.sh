rm -rf coverage/

# echo "Running tests..."

# dart	--disable-service-auth-codes \
# 	--enable-vm-service=9292 \
# 	--pause-isolates-on-exit \
# 	test/.test_cov.dart &

# echo "Collecting Test Coverage..."

# collect_coverage \
#     --port=9292 \
#     --out=coverage/cov.json \
#     --wait-paused \
#     --resume-isolates

echo "Generating LCOV File..."

# format_coverage --lcov --in=coverage/cov.json --out=coverage/lcov.info --packages=.packages --report-on=lib

pub run test_cov

genhtml coverage/lcov.info -o coverage/ 

xdg-open coverage/index.html 
