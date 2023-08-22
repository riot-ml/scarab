type t = {
  name: string;
  runs: int;
  op: unit -> (unit, string) result
}
