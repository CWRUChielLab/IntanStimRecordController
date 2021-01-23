# Change Log

* Increase limits for phase durations in stimulation dialog window ([#1][pr-1])
    * First and second phase durations were capped at 5 ms each. These were
      increased to allow for the longest possible pulses permitted by the
      hardware (~2-3 seconds, depending on sampling period).

[pr-1]: https://github.com/CWRUChielLab/IntanStimRecordController/pull/1
