var safePredicate = predicate => {
    return (...args) => {
        try {
            return predicate(...args);
        } catch {
            return false;
        }
    };
}

var patch = (object, property, wrapper) => {
    const original = object[property];
    object[property] = (...args) => wrapper(original, ...args);
    Object.assign(object[property], original);
    object[property].toString = () => original.toString();
};

var Modules = {
    _MODULES: (() => {
        let webpackRequire;
        window.webpackChunksteamui.push([
            [Symbol('dummy')],
            {},
            require => webpackRequire = require,
        ]);
        const modules = {};
        for (const [id] of Object.entries(webpackRequire.m)) {
            try {
                modules[id] = webpackRequire(id);
            } catch {}
        }
        return modules;
    })(),

    find: predicate => {
        for (const module of Object.values(Modules._MODULES)) {
            try {
                if (safePredicate(predicate)(module)) return module;
            } catch {}
        }
    },

    findExport: predicate => {
        for (const module of Object.values(Modules._MODULES)) {
            if (!module) continue;
            for (const exportValue of Object.values(module))
                if (safePredicate(predicate)(exportValue))
                    return exportValue;
        }
    },

    findByExport: predicate => {
        return Modules.find(module => {
            if (!module) return false;
            for (const exportValue of Object.values(module))
                if (safePredicate(predicate)(exportValue))
                    return true;
            return false;
        });
    },
};

var ReactUtils = {
    ROOT_FIBER: root[Object.keys(root).find(k => k.startsWith('__reactContainer$'))],

    findFiber: (root, predicate, visited = new Set()) => {
        if (visited.has(root))
            return;
        visited.add(root);
        if (!root || typeof root !== 'object')
            return;
        if (safePredicate(predicate)(root))
            return root;
        if (Array.isArray(root))
            return root
                .map(x => ReactUtils.findFiber(x, predicate, visited))
                .find(x => x);
        for (const key of ["child", "sibling", "children", "props"]) {
            const result = ReactUtils.findFiber(root[key], predicate, visited);
            if (result)
                return result;
        }
    },
};

var SteamComponents = {
    quickAccessMenuClasses: Modules.find(m =>
        m.Title &&
        m.QuickAccessMenu &&
        m.BatteryDetailsLabels
    ),

    showModalRaw: Modules.findExport(e =>
        e.toString().includes('props.bDisableBackgroundDismiss') &&
        !e.prototype.Cancel
    ),

    DialogButton: Modules.findExport(e =>
        e.render.toString().includes('"DialogButton","_DialogLayout","Secondary"')
    ),

    ConfirmModal: Modules.findExport(e =>
        e.toString().includes('bUpdateDisabled') &&
        e.toString().includes('closeModal') &&
        e.toString().includes('onGamepadCancel')
    ),

    IconsModule: Modules.find(m =>
        m.AddContained &&
        m.CustomizeSteamDeck
    ),

    PanelSection: Modules.findExport(e =>
        e.toString().includes('.PanelSection')
    ),
    PanelSectionRow: (() => {
        const mod = Modules.findByExport(e =>
            e.toString().includes('.PanelSection')
        );
        return Object.values(mod).find(e =>
            !e.toString().includes('.PanelSection')
        );
    })(),
};

var React = Modules.find(m =>
    m.useState &&
    m.createElement
);

var addTab = tabs => {
    const key = "QuickAccessScripts";
    if (!tabs.find(tab => tab.key === key))
        tabs.push({
            key: key,
            tab: React.createElement(
                React.Fragment,
                null,
                SteamComponents.IconsModule.Inventory(),
            ),
            panel: React.createElement(ScriptsPanel),
        });
};

var showModal = (title, description) => SteamComponents.showModalRaw(
    React.createElement(
        SteamComponents.ConfirmModal,
        {
            bAlertDialog: true,
            strTitle: title,
            strDescription: description,
        },
    ),
    window,
);

const ScriptsPanel = () => {
    const [running, setRunning] = React.useState([]);
    const [scripts, setScripts] = React.useState([]);

    const updateScripts = () => {
        fetch(`${window.QuickAccessScriptsBaseURL}/scripts`)
        .then(res => res.json())
        .then(data => {
            setRunning(data.filter(x => x.running).map(x => x.id));
            setScripts(data);
        });
    };
    React.useEffect(updateScripts, []);

    return React.createElement(
        React.Fragment,
        null,
        React.createElement(
            'div',
            { className: SteamComponents.quickAccessMenuClasses.Title },
            'Scripts',
        ),
        React.createElement(
            SteamComponents.PanelSection,
            null,
            React.createElement(
                'div',
                { style: { height: '8px'} },
            ),
            ...scripts.map(script =>
                React.createElement(
                    SteamComponents.PanelSectionRow,
                    { style: { paddingTop: '16px' } },
                    React.createElement(
                        SteamComponents.DialogButton,
                        {
                            disabled: running.includes(script.id),
                            onClick: () => {
                                setRunning(prev => [...prev, script.id]);
                                fetch(`${window.QuickAccessScriptsBaseURL}/run`, {
                                    method: 'POST',
                                    body: JSON.stringify({ id: script.id, name: script.name })
                                })
                                    .then(res => res.text())
                                    .then(body => { if (body.trim()) showModal(script.name, body); })
                                    .finally(updateScripts);
                            },
                        },
                        script.name,
                    ),
                ),
            ),
        ),
    );
};

var qamRender = Modules.findExport(e =>
    e.type.toString().includes('QuickAccessMenuBrowserView')
);
var qamFiber = ReactUtils.findFiber(
    ReactUtils.ROOT_FIBER,
    f => f.elementType == qamRender
);
patch(qamRender, 'type', (original, ...args) => {
    const render = original(...args);
    const navFiber = ReactUtils.findFiber(render, x => x.props.onFocusNavDeactivated);
    patch(navFiber, 'type', (original, ...args) => {
        const render = original(...args);
        const tabsFiber = ReactUtils.findFiber(render, x => x.props.tabs);
        addTab(tabsFiber.props.tabs);
        return render;
    });
    return render;
});
qamFiber.type = qamFiber.elementType.type;
qamFiber.alternate.type = qamFiber.type;
