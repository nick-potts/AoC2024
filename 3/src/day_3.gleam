import gleam/int
import gleam/io
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(contents) = simplifile.read("input.txt")
  let part1 = process_contents(contents, 0, True)
  let part2 = process_contents_with_toggles(contents, 0)

  io.println("Part 1: " <> int.to_string(part1))
  io.println("Part 2: " <> int.to_string(part2))
}

fn process_contents(contents: String, sum: Int, enabled: Bool) -> Int {
  case find_mul(contents) {
    Ok(rest_with_numbers) -> {
      case check_mul(rest_with_numbers) {
        Ok(#(a, b, remaining)) -> {
          case parse_numbers(a, b) {
            Ok(product) -> {
              process_contents(remaining, sum + product, enabled)
            }
            Error(Nil) -> process_contents(remaining, sum, enabled)
          }
        }
        Error(Nil) -> {
          case string.pop_grapheme(rest_with_numbers) {
            Ok(#(_, rest)) -> process_contents(rest, sum, enabled)
            Error(Nil) -> sum
          }
        }
      }
    }
    Error(Nil) -> sum
  }
}

fn process_contents_with_toggles(contents: String, sum: Int) -> Int {
  case find_next_instruction(contents) {
    Ok(#("mul", rest_with_numbers)) -> {
      case check_mul(rest_with_numbers) {
        Ok(#(a, b, remaining)) -> {
          case parse_numbers(a, b) {
            Ok(product) ->
              process_contents_with_toggles(remaining, sum + product)
            Error(Nil) -> process_contents_with_toggles(remaining, sum)
          }
        }
        Error(Nil) -> {
          case string.pop_grapheme(rest_with_numbers) {
            Ok(#(_, rest)) -> process_contents_with_toggles(rest, sum)
            Error(Nil) -> sum
          }
        }
      }
    }
    Ok(#("do", rest)) -> process_contents_with_toggles(rest, sum)
    Ok(#("don't", rest)) -> process_contents_disabled(rest, sum)
    Error(Nil) -> sum
    Ok(#(_, _)) -> sum
  }
}

fn process_contents_disabled(contents: String, sum: Int) -> Int {
  case find_next_instruction(contents) {
    Ok(#("do", rest)) -> process_contents_with_toggles(rest, sum)
    Ok(#(_, rest)) -> process_contents_disabled(rest, sum)
    Error(Nil) -> sum
  }
}

fn find_next_instruction(contents: String) -> Result(#(String, String), Nil) {
  case string.starts_with(contents, "mul(") {
    True -> Ok(#("mul", string.drop_start(contents, 4)))
    False -> {
      case string.starts_with(contents, "do(") {
        True -> Ok(#("do", string.drop_start(contents, 3)))
        False -> {
          case string.starts_with(contents, "don't(") {
            True -> Ok(#("don't", string.drop_start(contents, 6)))
            False -> {
              case string.pop_grapheme(contents) {
                Ok(#(_, rest)) -> find_next_instruction(rest)
                Error(Nil) -> Error(Nil)
              }
            }
          }
        }
      }
    }
  }
}

fn parse_numbers(a: String, b: String) -> Result(Int, Nil) {
  case int.parse(a), int.parse(b) {
    Ok(num1), Ok(num2) -> Ok(num1 * num2)
    _, _ -> Error(Nil)
  }
}

pub fn find_mul(contents: String) -> Result(String, Nil) {
  case string.starts_with(contents, "mul(") {
    True -> Ok(string.drop_start(contents, 4))
    False -> {
      case string.pop_grapheme(contents) {
        Ok(#(_, rest)) -> find_mul(rest)
        Error(Nil) -> Error(Nil)
      }
    }
  }
}

fn check_mul(contents: String) -> Result(#(String, String, String), Nil) {
  case match_digits(contents) {
    Ok(#(a, rest)) ->
      case match_comma(rest) {
        Ok(#(_, after_comma)) ->
          case match_digits(after_comma) {
            Ok(#(b, remaining)) -> {
              case string.pop_grapheme(remaining) {
                Ok(#(")", rest_of_string)) -> {
                  case string.length(a) <= 3 && string.length(b) <= 3 {
                    True -> Ok(#(a, b, rest_of_string))
                    False -> Error(Nil)
                  }
                }
                _ -> Error(Nil)
              }
            }
            Error(Nil) -> Error(Nil)
          }
        Error(Nil) -> Error(Nil)
      }
    Error(Nil) -> Error(Nil)
  }
}

fn match_digits(input: String) -> Result(#(String, String), Nil) {
  case match_digit(input) {
    Ok(#(first_digit, rest)) -> {
      let #(num, remaining) = collect_digits(first_digit, rest)
      Ok(#(num, remaining))
    }
    Error(Nil) -> Error(Nil)
  }
}

fn collect_digits(acc: String, input: String) -> #(String, String) {
  case string.pop_grapheme(input) {
    Ok(#(digit, rest)) ->
      case is_single_digit(digit) {
        True -> collect_digits(acc <> digit, rest)
        False -> #(acc, input)
      }
    Error(Nil) -> #(acc, input)
  }
}

fn match_comma(input: String) -> Result(#(String, String), Nil) {
  case string.pop_grapheme(input) {
    Ok(#(char, rest)) ->
      case char {
        "," -> Ok(#(char, rest))
        _ -> Error(Nil)
      }
    _ -> Error(Nil)
  }
}

fn match_digit(input: String) -> Result(#(String, String), Nil) {
  case string.pop_grapheme(input) {
    Ok(#(digit, rest)) ->
      case is_single_digit(digit) {
        True -> Ok(#(digit, rest))
        False -> Error(Nil)
      }
    _ -> Error(Nil)
  }
}

fn is_single_digit(s: String) -> Bool {
  case s {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> True
    _ -> False
  }
}
}
