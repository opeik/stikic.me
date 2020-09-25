---
layout: post
tags: [C++]
title: C++ release mode assertions
date: 2020-09-24 19:51 +0800
hidden: false
---

Recently I was optimizing some performance-critical C++ code while trying
to maintain invariants aggressively. Unfortunately, the standard C++ `assert`
macro only executes on debug builds, which didn't meet my needs. I decided to
write my own instead. While I'd like to avoid macros, since `__FILE__`
and `__LINE__` are macros; my custom assertion would _also_ have to be a macro.

I ended up with the following:

```cpp
#include <cstdlib>
#include <iostream>
#include <exception>
#include <string>

// Get the most detailed function signature for this compiler.
#if defined(__GNUC__) || defined(__clang__)
  #define PRETTY_FUNCTION __PRETTY_FUNCTION__
#elif defined(_MSC_VER)
  #define PRETTY_FUNCTION __FUNCSIG__
#else
  #define PRETTY_FUNCTION __func__
#endif

// Define the regular assertion macro.
#define assertion(expression, msg)                                            \
  assertion_impl(expression, msg, #expression, __FILE__, __LINE__, PRETTY_FUNCTION)

// Define the debug only assertion macro.
#ifdef NDEBUG
  #define assertion_debug(expression, msg) ((void)0)
#else
  #define assertion_debug(expression, msg)                                    \
    assertion_impl(expression, msg, #expression, __FILE__, __LINE__, PRETTY_FUNCTION)
#endif

inline auto assertion_impl(bool condition, const std::string &msg,
                      const std::string &expression, const std::string &file_path,
                      std::size_t line_num, const std::string &function_name) -> void {
  using namespace std::string_literals;

  if (!condition) {
    const auto error = "\nAssertion '"s + expression + "' failed: "s + msg +
                       "\n  in "s + function_name + "\n  at "s + file_path +
                       ":"s + std::to_string(line_num) + "\n  "s;

    std::cerr << error;
    std::terminate();
  }
}
```

With this code, `assertion` will **always** execute, whereas `assertion_debug`
will only execute on debug builds. If an assertion fails, you should get
something similar to this outputted to stderr:

```
Assertion '42 != 42' failed: Oh no
  in int main()
  at ../src/Main.cpp:10
```

Check out this [wandbox](https://wandbox.org/permlink/4D35CsFqEAhKBy7B) for a live demo.
