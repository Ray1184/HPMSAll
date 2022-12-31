package org.ray1184.hpms.batch.tasks.utils;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.ray1184.hpms.batch.HPMSParams;
import org.zeroturnaround.exec.ProcessExecutor;
import org.zeroturnaround.exec.ProcessResult;
import org.zeroturnaround.exec.stream.slf4j.Slf4jStream;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Slf4j
public enum NativeConverter {

	// @formatter:off
	WALKMAP {
		@Override
		public boolean convert(HPMSParams params, Object... args) {
			String exe = buildExePath(params, params.getIniParam(HPMSParams.IniParam.NATIVE_WALKMAPS_CONVERTER));
			String input = (String) args[0];
			String output = input.replace(".obj.walkmap", ".walkmap");
			return exec(exe, () -> FileUtils.deleteQuietly(new File(input)), input, output);
		}
	},
	OGRE_MESH {
		@Override
		public boolean convert(HPMSParams params, Object... args) {
			String exe = buildExePath(params, params.getIniParam(HPMSParams.IniParam.NATIVE_OGRE_CONVERTER));
			String input = (String) args[0];
			return exec(exe, () -> FileUtils.deleteQuietly(new File(input)), input);
		}
	};
	// @formatter:on

	public abstract boolean convert(HPMSParams params, Object... args);

	@SneakyThrows
	private static boolean exec(String exe, ResultCallback onSuccessCallback, String... args) {
		List<String> commandsTokenList = new ArrayList<>();
		commandsTokenList.add(exe);
		commandsTokenList.addAll(Arrays.asList(args));
		ProcessResult res = new ProcessExecutor()//
				.command(commandsTokenList)//
				.redirectError(Slf4jStream.of(NativeConverter.class).asError())//
				.readOutput(true)//
				.execute();
		log.debug("Process {} output: {}", exe, res.outputUTF8());
		if (res.getExitValue() == 0) {
			onSuccessCallback.apply();
			return true;
		}
		log.error("Native conversion finished with errors");
		return false;
	}

	private static String buildExePath(HPMSParams params, Object iniParam) {
		return params.getSysResPath() + File.separator + iniParam.toString();
	}

	@FunctionalInterface
	private interface ResultCallback {
		void apply();
	}
}
