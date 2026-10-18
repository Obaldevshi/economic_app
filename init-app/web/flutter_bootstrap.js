{{flutter_js}}
{{flutter_build_config}}

(() => {
  const config = {
    canvasKitBaseUrl: new URL('canvaskit/', document.baseURI).href,
  };
  try {
    // The current Flutter worker is a retirement stub that unregisters itself
    // and reloads its clients. Registering it on every boot causes a reload loop.
    // Web uses live API data; Android offline storage is independent of this.
    Promise.resolve(_flutter.loader.load({
      config,
      onEntrypointLoaded: async (engineInitializer) => {
        try {
          window.sberigaStartup.stage('engine');
          const appRunner = await engineInitializer.initializeEngine(config);
          window.sberigaStartup.stage('app');
          await appRunner.runApp();
        } catch (error) {
          window.sberigaStartup.fail(error);
        }
      },
    })).catch((error) => window.sberigaStartup.fail(error));
  } catch (error) {
    window.sberigaStartup.fail(error);
  }
})();
