export const LiveViewResponsiveMediaQueryHook = {
  mounted() {
    const mql = window.matchMedia(this.el.dataset.query);
    mql.addEventListener("change", (e) => this.__changeHandler(e.matches));
    this.__mql = mql;
    this.__changeHandler(mql.matches);
  },
  updated() {
    this.__changeHandler(this.__mql.matches);
  },
  __changeHandler(matches) {
    if (matches) {
      this.el.style.display = "unset";
    } else {
      this.el.style.display = "none";
    }
  },
};
