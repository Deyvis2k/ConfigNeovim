local gobject_h = [[
#pragma once

#include <glib-object.h>

G_BEGIN_DECLS

#define %s_TYPE_%s (%s_%s_get_type())

G_DECLARE_FINAL_TYPE(%s, %s_%s, %s, %s, GObject)

%s* %s_%s_new(void);

G_END_DECLS
]]

local gobject_c = [[
#include "%s.h"

enum {
    PROP_0,
    PROP_LAST
};

static GParamSpec *params[PROP_LAST] = { nullptr };

struct _%s {
    GObject parent_instance;
};

G_DEFINE_FINAL_TYPE(%s, %s_%s, G_TYPE_OBJECT)

static void
%s_%s_init(%s *self)
{
    /* Initialize instance */
}

static void 
%s_%s_dispose(GObject *object)
{
    /* Dispose instance */
    G_OBJECT_CLASS(%s_%s_parent_class)->dispose(object);
}

static void
%s_%s_finalize(GObject *object)
{
    /* Finalize instance */
    G_OBJECT_CLASS(%s_%s_parent_class)->finalize(object);
}

static void 
%s_%s_set_property(
    GObject         *object, 
    guint           property_id, 
    const GValue    *value, 
    GParamSpec      *pspec
)
{
    %s* self = %s_%s(object);
    switch (property_id) {
        default:
            G_OBJECT_WARN_INVALID_PROPERTY_ID(object, property_id, pspec);
    }
}

static void 
%s_%s_get_property(
    GObject     *object, 
    guint       property_id, 
    GValue      *value, 
    GParamSpec  *pspec
)
{
    %s* self = %s_%s(object);
    switch (property_id) {
        default:
            G_OBJECT_WARN_INVALID_PROPERTY_ID(object, property_id, pspec);
    }
}

static void
%s_%s_class_init(%sClass *klass)
{
    GObjectClass *object_class = G_OBJECT_CLASS(klass);
    
    object_class->dispose = %s_%s_dispose;
    object_class->finalize = %s_%s_finalize;

    object_class->set_property = %s_%s_set_property;
    object_class->get_property = %s_%s_get_property;

    g_object_class_install_properties(object_class, PROP_LAST, params);
}

%s*
%s_%s_new(void)
{
    return g_object_new(%s_TYPE_%s, nullptr);
}
]]

local function split_pascal_case(str)
    local parts = {}
    for word in str:gmatch("[A-Z][a-z0-9]*") do
        table.insert(parts, word)
    end
    if #parts == 0 then
        return str:lower(), str:lower()
    end

    local prefix = parts[1]:lower()
    table.remove(parts, 1)
    local rest = table.concat(parts, "_"):lower()
    if rest == "" then
        rest = prefix
    end
    return prefix, rest
end

-- Converte PascalCase (sem prefixo) para UPPER_SNAKE_CASE (para macros)
local function to_upper_snake_case(str)
    return str:gsub("(%l)(%u)", "%1_%2"):upper()
end

local function create_new_gobject_file()
    local file_name = vim.fn.input("Nome do arquivo (ex: my-object-example): ")
    if file_name == "" then
        Snacks.notify.error("Nome do arquivo não pode ser vazio")
        return
    end

    local pascal_case_object = vim.fn.input("Nome do objeto (PascalCase, ex: MyObjectExample): ")
    if pascal_case_object == "" then
        Snacks.notify.error("Nome do objeto (PascalCase) não pode ser vazio")
        return
    end

    local file_path = vim.fn.input("Path do arquivo: ", vim.fn.getcwd() .. "/")
    if file_path == "" then
        Snacks.notify.error("Path do arquivo não pode ser vazio")
        return
    end

    local prefix, name = split_pascal_case(pascal_case_object)
    local PREFIX = prefix:upper()
    local NAME = name:gsub("(%l)(%u)", "%1_%2"):upper()

    local h_path = file_path .. file_name .. ".h"
    local h_file = io.open(h_path, "w+")
    if not h_file then
        Snacks.notify.error("Erro ao abrir arquivo .h")
        return
    end

    h_file:write(string.format(
        gobject_h,
        PREFIX, NAME, prefix, name, -- define
        pascal_case_object, prefix, name, PREFIX, NAME, -- declare type
        pascal_case_object, prefix, name -- new
    ))
    h_file:close()

    -- Cria .c
    local c_path = file_path .. file_name .. ".c"
    local c_file = io.open(c_path, "w+")
    if not c_file then
        Snacks.notify.error("Erro ao abrir arquivo .c")
        return
    end

    c_file:write(string.format(
        gobject_c,
        file_name,
        pascal_case_object, -- struct
        pascal_case_object, prefix, name, -- type
        prefix, name, pascal_case_object, -- init
        prefix, name, prefix, name, -- dispose
        prefix, name, prefix, name, -- finalize
        prefix, name, pascal_case_object, PREFIX, NAME, -- set property
        prefix, name, pascal_case_object, PREFIX, NAME, -- get property
        prefix, name, pascal_case_object, -- class_init
        prefix, name, -- class_init dispose
        prefix, name, -- class_init finalize
        prefix, name, -- class_init set property
        prefix, name, -- class_init get property
        pascal_case_object, prefix, name, PREFIX, NAME -- new
    ))
    c_file:close()

    Snacks.notify.info("Arquivos criados: " .. h_path .. " e " .. c_path)
end

return {
    create_new_gobject_file = create_new_gobject_file
}
