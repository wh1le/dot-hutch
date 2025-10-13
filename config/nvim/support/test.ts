const myFunction = function () {
  return {
    anotherFunction: function (test) {
      return "hello";
    },
    moreFunction: function (test) {
      return "hello";
    },
  };
};

myFunction().anotherFunction;
