// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:file/memory.dart';
import 'package:flutter_tools/src/base/config.dart';
import 'package:flutter_tools/src/base/file_system.dart';
import 'package:flutter_tools/src/base/logger.dart';
import 'package:flutter_tools/src/base/terminal.dart';
import 'package:mockito/mockito.dart';
import 'package:platform/platform.dart';

import '../src/common.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  Config config;
  MemoryFileSystem memoryFileSystem;

  setUp(() {
    memoryFileSystem = MemoryFileSystem();
    final File file = memoryFileSystem.file('example');
    config = Config(file: file, logger: MockLogger());
  });
  testWithoutContext('Config get set value', () async {
    expect(config.getValue('foo'), null);
    config.setValue('foo', 'bar');
    expect(config.getValue('foo'), 'bar');
    expect(config.keys, contains('foo'));
  });

  testWithoutContext('Config get set bool value', () async {
    expect(config.getValue('foo'), null);
    config.setValue('foo', true);
    expect(config.getValue('foo'), true);
    expect(config.keys, contains('foo'));
  });

  testWithoutContext('Config containsKey', () async {
    expect(config.containsKey('foo'), false);
    config.setValue('foo', 'bar');
    expect(config.containsKey('foo'), true);
  });

  testWithoutContext('Config removeValue', () async {
    expect(config.getValue('foo'), null);
    config.setValue('foo', 'bar');
    expect(config.getValue('foo'), 'bar');
    expect(config.keys, contains('foo'));
    config.removeValue('foo');
    expect(config.getValue('foo'), null);
    expect(config.keys, isNot(contains('foo')));
  });

  testWithoutContext('Config parse error', () {
    final BufferLogger bufferLogger = BufferLogger(
      terminal: AnsiTerminal(
        stdio: null,
        platform: const LocalPlatform(),
      ),
      outputPreferences: OutputPreferences.test(),
    );
    final File file = memoryFileSystem.file('example')
      ..writeAsStringSync('{"hello":"bar');
    config = Config(file: file, logger: bufferLogger);

    expect(file.existsSync(), false);
    expect(bufferLogger.errorText, contains('Failed to decode preferences'));
  });
}
