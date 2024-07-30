export const LiveviewResponsiveHook = createLiveviewResponsiveHook();

export function createLiveviewResponsiveHook(debounceTimeout = 10) {
  return {
    mounted() {
      this.__queries = {};

      this.handleEvent(
        "liveview-responsive-sync",
        this.__handleSyncEvent.bind(this)
      );
    },
    destroyed() {
      Object.values(this.__queries).forEach(({ mql, listener }) => {
        mql.removeEventListener("change", listener);
      });
    },

    /**
     * @type {Object.<string, {
     *  query: string,
     *  mql: MediaQueryList,
     *  listener: (e: MediaQueryListEvent) => void
     * }>}
     */
    __queries: {},

    __dataToBePushed: {},
    __pushTimeout: null,
    __push(data) {
      if (this.__pushTimeout) {
        clearTimeout(this.__pushTimeout);
      }

      Object.assign(this.__dataToBePushed, data);

      this.__pushTimeout = setTimeout(() => {
        this.pushEventTo(
          this.el,
          "liveview-responsive-change",
          this.__dataToBePushed
        );
        this.__dataToBePushed = {};
        this.__pushTimeout = null;
      }, debounceTimeout);
    },

    __handleSyncEvent(data) {
      const dataToBePushed = Object.entries(data).reduce(
        (dataToBePushed, [name, query]) => {
          if (this.__queries[name]) {
            this.__queries[name].mql.removeEventListener(
              "change",
              this.__queries[name].listener
            );
          }

          const mql = window.matchMedia(query);
          const listener = (e) => {
            this.__push({
              [name]: e.matches,
            });
          };

          mql.addEventListener("change", listener);

          this.__queries[name] = {
            query,
            mql,
            listener,
          };

          return {
            ...dataToBePushed,
            [name]: mql.matches,
          };
        },
        {}
      );

      this.__push(dataToBePushed);
    },
  };
}
