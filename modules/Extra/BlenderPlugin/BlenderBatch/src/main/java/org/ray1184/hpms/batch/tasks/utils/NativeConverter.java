package org.ray1184.hpms.batch.tasks.utils;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.ray1184.hpms.batch.HPMSParams;
import org.zeroturnaround.exec.ProcessExecutor;
import org.zeroturnaround.exec.stream.slf4j.Slf4jStream;

import java.io.File;

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
			String output = input.replace(".mesh.xml", ".mesh");
			output = output.replace(".skeleton.xml", ".skeleton");
			return exec(exe, () -> FileUtils.deleteQuietly(new File(input)), input, output);
		}
	};
	// @formatter:on

	public abstract boolean convert(HPMSParams params, Object... args);

	@SneakyThrows
	private static boolean exec(String exe, ResultCallback onSuccessCallback, String... args) {
		String[] commandsToken = new String[args.length + 1];
		commandsToken[0] = exe;
		if (args.length - 1 >= 0) {
			System.arraycopy(args, 0, commandsToken, 1, args.length - 1);
		}
		String output = new ProcessExecutor().command(commandsToken)//
				.redirectError(Slf4jStream.of(NativeConverter.class).asError())//
				.readOutput(true)//
				.execute()//
				.outputUTF8();
		if (output.equals("0")) {
			onSuccessCallback.apply();
			return true;
		}
		log.error("Problem executing command {}, returning code {}", exe, output);
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
