class RunSync {
  final Future<void> Function() run;

  RunSync(this.run);

  Future<void> call() => run();
}