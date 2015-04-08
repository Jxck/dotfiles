function assert(actual, expected) {
  console.log('.');
  console.assert(actual === expected, '\nact: ' + actual + '\nexp: ' + expected);
}

function test1() {
};

function test2() {
};

function run() {
  test1();
  test2();
};
run();
